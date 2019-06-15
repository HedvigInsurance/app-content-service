//
//  AssetsMiddleware.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-03.
//

import Foundation
import Vapor

final class AssetsMiddleware: Middleware {
    /// The public directory.
    /// - note: Must end with a slash.
    private let publicDirectory: String
    
    private let fileio: FileIO

    /// Creates a new `AssetsMiddleware`.
    public init(publicDirectory: String, fileio: FileIO) {
        self.publicDirectory = publicDirectory.hasSuffix("/") ? publicDirectory : publicDirectory + "/"
         self.fileio = fileio
    }

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // make a copy of the path
        var path = req.url.path

        print(path)
        
        let approvedPath = "app-content-service/"

        // only serve files in Public if url contains approvedPath
        if !path.contains(approvedPath) {
            return next.respond(to: req)
        }

        path = path.replacingOccurrences(of: approvedPath, with: "")

        // path must be relative.
        while path.hasPrefix("/") {
            path = String(path.dropFirst())
        }

        // protect against relative paths
        guard !path.contains("../") else {
            return self.fileio.eventLoop.makeFailedFuture(Abort(.forbidden))
        }
        
        // create absolute file path
        let filePath = publicDirectory + path
        
        print(filePath)
        
        // check if file exists and is not a directory
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir), !isDir.boolValue else {
            return next.respond(to: req)
        }
        
        // stream the file
        let res = self.fileio.streamFile(at: filePath, for: req)
        return self.fileio.eventLoop.makeSucceededFuture(res)
    }
}

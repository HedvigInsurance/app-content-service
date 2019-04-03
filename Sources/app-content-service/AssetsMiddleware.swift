//
//  AssetsMiddleware.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-03.
//

import Foundation
import Vapor

final class AssetsMiddleware: Middleware, ServiceType {
    /// See `ServiceType`.
    public static func makeService(for container: Container) throws -> AssetsMiddleware {
        return try .init(publicDirectory: container.make(DirectoryConfig.self).workDir + "Public/")
    }
    
    /// The public directory.
    /// - note: Must end with a slash.
    private let publicDirectory: String
    
    /// Creates a new `AssetsMiddleware`.
    public init(publicDirectory: String) {
        self.publicDirectory = publicDirectory.hasSuffix("/") ? publicDirectory : publicDirectory + "/"
    }
    
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        // make a copy of the path
        var path = req.http.url.path
        
        let approvedPath = "app-content-service/"
        
        // only serve files in Public if url contains approvedPath
        if !path.contains(approvedPath) {
            return try next.respond(to: req)
        }
        
        path = path.replacingOccurrences(of: approvedPath, with: "")
        
        // path must be relative.
        while path.hasPrefix("/") {
            path = String(path.dropFirst())
        }
        
        // protect against relative paths
        guard !path.contains("../") else {
            throw Abort(.forbidden)
        }
        
        // create absolute file path
        let filePath = publicDirectory + path
        
        // check if file exists and is not a directory
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir), !isDir.boolValue else {
            return try next.respond(to: req)
        }
        
        // stream the file
        return try req.streamFile(at: filePath)
    }
}

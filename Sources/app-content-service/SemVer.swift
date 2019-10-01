//
//  SemVer.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-29.
//

import Foundation

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct SemVer {
    let major: Int
    let minor: Int
    let patch: Int
    
    static func parse(version: String) -> SemVer {
        let parts = version.split(separator: ".")
        
        let fallbackSemVer = SemVer(major: 0, minor: 0, patch: 0)
        
        let partOne = parts[safe: 0] ?? "0"
        let partTwo = parts[safe: 1] ?? "0"
        let partThree = parts[safe: 2] ?? "0"
        
        guard let major = Int(String(partOne)),
            let minor = Int(String(partTwo)),
            let patch = Int(String(partThree)) else {
                return fallbackSemVer
        }
        
        return SemVer(
            major: major,
            minor: minor,
            patch: patch
        )
    }
}

enum SemVerError: Error {
    case parse
}

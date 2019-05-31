//
//  SemVer.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-29.
//

import Foundation

struct SemVer {
    let major: Int
    let minor: Int
    let patch: Int
    
    static func parse(version: String) throws -> SemVer {
        let parts = version.split(separator: ".")
        
        
        guard let major = Int(String(parts[0])),
            let minor = Int(String(parts[1])),
            let patch = Int(String(parts[2])) else {
                throw SemVerError.parse
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

//
//  Platform.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-29.
//

import Foundation
import Graphiti

enum Platform: String, CaseIterable {
    case Android
    case iOS
}

extension Platform: InputType, OutputType {
    init(map: Map) throws {
        guard
            let name = map.string,
            let platform = Platform(rawValue: name)
            else {
                throw MapError.incompatibleType
        }
        
        self = platform
    }
    
    func asMap() throws -> Map {
        return rawValue.map
    }
}

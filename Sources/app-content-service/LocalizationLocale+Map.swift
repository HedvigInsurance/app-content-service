//
//  LocalizationKey+Map.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-11.
//

import Foundation
import GraphQL
import Graphiti
import Vapor

extension Localization.Locale: InputType, OutputType {
    init(map: Map) throws {
        guard
            let name = map.string,
            let locale = Localization.Locale(rawValue: name)
            else {
                throw MapError.incompatibleType
        }
        
        self = locale
    }
    
    func asMap() throws -> Map {
        return rawValue.map
    }
}

extension Localization.Locale: Schemable {
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
    ) throws {
        try schema.enum(type: Localization.Locale.self) { language in
            try Localization.Locale.allCases.forEach { languageEnumValue in
                try language.value(
                    name: languageEnumValue.rawValue,
                    value: languageEnumValue,
                    description: ""
                )
            }
        }
    }
}

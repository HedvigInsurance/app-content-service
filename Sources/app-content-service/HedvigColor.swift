//
//  HedvigColor.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-11.
//

import Foundation
import GraphQL
import Graphiti
import Vapor

enum HedvigColor: String, InputType, OutputType, CaseIterable {
    case pink = "Pink"
    case turquoise = "Turquoise"
    case purple = "Purple"
    case darkPurple = "DarkPurple"
    case blackPurple = "BlackPurple"
    case darkGray = "DarkGray"
    case lightGray = "LightGray"
    case white = "White"
    case black = "Black"
    case offBlack = "OffBlack"
    case offWhite = "OffWhite"
    
    init(map: Map) throws {
        guard
            let name = map.string,
            let color = HedvigColor(rawValue: name)
            else {
                throw MapError.incompatibleType
        }
        
        self = color
    }
    
    func asMap() throws -> Map {
        return rawValue.map
    }
}

extension HedvigColor: Schemable {
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
    ) throws {
        try schema.enum(type: HedvigColor.self) { hedvigColor in
            try HedvigColor.allCases.forEach { hedvigColorEnumValue in
                try hedvigColor.value(
                    name: hedvigColorEnumValue.rawValue,
                    value: hedvigColorEnumValue,
                    description: ""
                )
            }
        }
    }
}

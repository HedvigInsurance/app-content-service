//
//  News.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-28.
//

import Foundation
import Graphiti
import Vapor

struct News: OutputType {
    let illustration: Icon
    let title: String
    let paragraph: String
}

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

struct NewsArguments: Arguments {
    let platform: Platform
    let sinceVersion: String
    let locale: Localization.Locale
}

extension News: Schemable {
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
        ) throws {
        
        try schema.object(type: News.self) { news in
            news.description = "A page in the `What's new`-screen in the app"
            
            try news.field(
                name: "illustration",
                type: Icon.self,
                description: "Illustration shown for the page"
            )
            
            try news.field(
                name: "title",
                type: String.self,
                description: "Text key for the title of the page"
            )
            
            try news.field(
                name: "paragraph",
                type: String.self,
                description: "Text key for the paragraph shown below the title"
            )
        }
        
        try schema.enum(type: Platform.self) { platform in
            try Platform.allCases.forEach { platformEnumValue in
                try platform.value(
                    name: platformEnumValue.rawValue,
                    value: platformEnumValue,
                    description: ""
                )
            }
        }
        
        try query.field(
            name: "news",
            type: [News].self
        ) { (_, arguments: NewsArguments, _, eventLoop, _) in
            return eventLoop
                .next()
                .newSucceededFuture(
                    result: NewsRepository.findSince(
                        version: try SemVer.parse(version: arguments.sinceVersion),
                        platform: arguments.platform,
                        locale: arguments.locale
                    )
                )
        }
    }
}

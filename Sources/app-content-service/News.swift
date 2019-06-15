//
//  News.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-28.
//

import Foundation
import Graphiti
import Vapor

struct News: Codable, FieldKeyProvider {
    let illustration: Icon
    let title: String
    let paragraph: String
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys: String {
        case illustration
        case title
        case paragraph
    }
}

extension News: Schemable {
    @AppSchemaBuilder static func build() -> AppComponent {
        Type(News.self) {
            Field(.illustration, at: \.illustration).description("Illustration shown for the page")
            Field(.title, at: \.title).description("Text key for the title of the page")
            Field(.paragraph, at: \.paragraph).description("Text key for the paragraph shown below the title")
        }.description("A page in the `What's new`-screen in the app")
        
        Enum(Platform.self) {
            Value(.iOS)
            Value(.Android)
        }
    }
}

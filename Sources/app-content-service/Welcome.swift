//
//  Welcome.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-06-28.
//

import Foundation
import Graphiti
import Vapor

struct Welcome: Codable, FieldKeyProvider {
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

extension Welcome: Schemable {
    @AppSchemaBuilder static func build() -> AppComponent {
        Type(Welcome.self) {
            Field(.illustration, at: \.illustration).description("Illustration shown for the page")
            Field(.title, at: \.title).description("Text key for the title of the page")
            Field(.paragraph, at: \.paragraph).description("Text key for the paragraph shown below the title")
        }.description("A page in the `Welcome`-screen in the app")
    }
}


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

extension Localization.Locale: Codable {}

extension Localization.Locale: Schemable {
    @AppSchemaBuilder static func build() -> AppComponent {
        Enum(Localization.Locale.self) {
            Value(.sv_SE)
            Value(.en_SE)
        }
    }
}

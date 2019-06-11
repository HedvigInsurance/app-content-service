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
    @SchemaBuilder<AppContentAPI, Request> static func build() -> SchemaComponent<AppContentAPI, Request> {
        Enum(Localization.Locale.self) {
            Value(.sv_SE)
            Value(.en_SE)
        }
    }
}

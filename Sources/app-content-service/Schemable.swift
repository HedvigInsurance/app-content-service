//
//  Schemable.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-02.
//

import Foundation
import Graphiti
import Vapor

typealias AppSchemaBuilder = SchemaBuilder<AppContentAPI, Request>
typealias AppComponent = SchemaComponent<AppContentAPI, Request>

protocol Schemable {
    @AppSchemaBuilder static func build() -> AppComponent
}

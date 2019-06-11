//
//  Schemable.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-02.
//

import Foundation
import Graphiti
import Vapor

protocol Schemable {
    @SchemaBuilder<AppContentAPI, Request> static func build() -> SchemaComponent<AppContentAPI, Request>
}

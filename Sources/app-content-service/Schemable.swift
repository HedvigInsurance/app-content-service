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
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
    ) throws
}

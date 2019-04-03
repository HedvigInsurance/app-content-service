//
//  CommonClaim.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-02.
//

import Foundation
import Graphiti
import Vapor

enum CommonClaimLayouts {
    case titleAndBulletpoints, emergency
}

struct CommonClaim: OutputType {
    let icon: Icon
    let title: String
    let description: String
}

let commonClaims = [
    CommonClaim(icon: Icon(name: "warning"), title: "test", description: "test")
]

extension CommonClaim: Schemable {
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
    ) throws {
        try schema.object(type: CommonClaim.self) { commonClaim in
            commonClaim.description = "An object containing content for a common claim"
            
            try commonClaim.field(
                name: "title",
                type: String.self,
                description: ""
            )
            
            try commonClaim.field(
                name: "description",
                type: String.self,
                description: ""
            )
            
            try commonClaim.field(
                name: "icon",
                type: Icon.self,
                description: ""
            )
        }
        
        try query.field(
            name: "commonClaims",
            type: [CommonClaim].self
        ) { (_, _, _, eventLoop, _) in
            return eventLoop.next().newSucceededFuture(result: commonClaims)
        }
    }
}

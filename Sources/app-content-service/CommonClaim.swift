//
//  CommonClaim.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-02.
//

import Foundation
import Graphiti
import GraphQL
import Vapor

struct BulletPoint: OutputType {
    let icon: Icon
    let title: String
    let description: String
}

protocol CommonClaimLayouts {
    var color: HedvigColor { get }
}

struct TitleAndBulletPoints: CommonClaimLayouts, OutputType {
    let color: HedvigColor
    let icon: Icon
    let title: String
    let buttonTitle: String
    let claimFirstMessage: String
    let bulletPoints: [BulletPoint]
}

struct Emergency: CommonClaimLayouts, OutputType {
    let color: HedvigColor
    let title: String
}

struct CommonClaim: OutputType {
    let icon: Icon
    let title: String
    let layout: CommonClaimLayouts
}

extension CommonClaim: Schemable {
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
    ) throws {
        try schema.object(type: BulletPoint.self) { bulletPoint in
            try bulletPoint.field(
                name: "title",
                type: String.self,
                description: ""
            )
            
            try bulletPoint.field(
                name: "description",
                type: String.self,
                description: ""
            )
            
            try bulletPoint.field(
                name: "icon",
                type: Icon.self,
                description: ""
            )
        }
        
        try schema.object(type: TitleAndBulletPoints.self) { titleAndBulletPoints in
            titleAndBulletPoints.description = "A layout with a title and some bullet points"
            
            try titleAndBulletPoints.field(
                name: "color",
                type: HedvigColor.self,
                description: "The color to show as the background"
            )
            
            try titleAndBulletPoints.field(
                name: "icon",
                type: Icon.self,
                description: ""
            )
            
            try titleAndBulletPoints.field(
                name: "title",
                type: String.self,
                description: ""
            )
            
            try titleAndBulletPoints.field(
                name: "buttonTitle",
                type: String.self,
                description: ""
            )
            
            try titleAndBulletPoints.field(
                name: "claimFirstMessage",
                type: String.self,
                description: ""
            )
            
            try titleAndBulletPoints.field(
                name: "bulletPoints",
                type: [BulletPoint].self,
                description: ""
            )
        }
        
        try schema.object(type: Emergency.self) { emergency in
            emergency.description = "The emergency layout shows a few actions for the user to rely on in the case of an emergency"
            try emergency.field(
                name: "color",
                type: HedvigColor.self,
                description: "The color to show as the background"
            )
            
            try emergency.field(
                name: "title",
                type: String.self,
                description: ""
            )
        }
        
        try schema.union(type: CommonClaimLayouts.self) { union in
            union.types = [TitleAndBulletPoints.self, Emergency.self]
        }
        
        try schema.object(type: CommonClaim.self) { commonClaim in
            commonClaim.description = "A list of claim types that are common to show for the user"
            
            try commonClaim.field(
                name: "title",
                type: String.self,
                description: "A title to show on the card of the common claim"
            )
            
            try commonClaim.field(
                name: "layout",
                type: CommonClaimLayouts.self,
                description: "The layout to use for the subpage regarding the common claim"
            )
            
            try commonClaim.field(
                name: "icon",
                type: Icon.self,
                description: "An icon to show on the card of the common claim"
            )
        }
        
        struct CommonClaimArguments: Arguments {
            let locale: Localization.Locale
        }
        
        try query.field(
            name: "commonClaims",
            type: [CommonClaim].self
        ) { (_, arguments: CommonClaimArguments, _, eventLoop, _) in
            
            let icon = Icon(name: "warning")
            let emergencyIcon = Icon(name: "warning")
            
            let commonClaims = [
                CommonClaim(
                    icon: icon,
                    title: "test",
                    layout: TitleAndBulletPoints(
                        color: .darkPurple,
                        icon: icon,
                        title: "test",
                        buttonTitle: "Anmäl försenat baggage",
                        claimFirstMessage: "Tråkigt att höra om ditt försenade baggage :(",
                        bulletPoints: [BulletPoint(icon: icon, title: "test", description: "test")]
                    )
                ),
                CommonClaim(
                    icon: emergencyIcon,
                    title: "test",
                    layout: Emergency(color: .darkPurple, title: "test")
                )
            ]
            
            return eventLoop.next().newSucceededFuture(result: commonClaims)
        }
    }
}

//
//  Icon.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-03.
//

import Foundation
import Graphiti
import Vapor

struct Icon: OutputType {
    let pdfUrl: String
    let svgUrl: String
    let vectorDrawableUrl: String
    
    init(name: String) {
        let base = "/app-content-service/"
        self.pdfUrl = "\(base)\(name).pdf"
        self.svgUrl = "\(base)\(name).svg"
        self.vectorDrawableUrl = "\(base)\(name).xml"
    }
}

extension Icon: Schemable {
    static func build(
        _ schema: SchemaBuilder<Void, Void, MultiThreadedEventLoopGroup>,
        _ query: ObjectTypeBuilder<Void, Void, MultiThreadedEventLoopGroup, Void>
    ) throws {
        try schema.object(type: Icon.self) { icon in
            icon.description = "A vectorized image to show to the user"
            
            try icon.field(
                name: "pdfUrl",
                type: String.self,
                description: "For iOS use"
            )
            
            try icon.field(
                name: "svgUrl",
                type: String.self,
                description: "For Web use"
            )
            
            try icon.field(
                name: "vectorDrawableUrl",
                type: String.self,
                description: "For Android use"
            )
        }
    }
}

extension Icon {
    static let warning = Icon(name: "warning")
    static let delayedLuggage = Icon(name: "delayed_luggage")
    static let compensation = Icon(name: "compensation")
    static let information = Icon(name: "information")
    static let record = Icon(name: "record")
    static let brokenPhone = Icon(name: "broken_phone")
    
    static let bonusRain = Icon(name: "referrals_bonus_rain")
}

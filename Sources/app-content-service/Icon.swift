//
//  Icon.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-03.
//

import Foundation
import Graphiti
import Vapor

struct Icon: Codable, FieldKeyProvider {
    let pdfUrl: String
    let svgUrl: String
    let vectorDrawableUrl: String
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case pdfUrl
        case svgUrl
        case vectorDrawableUrl
    }
    
    init(name: String) {
        let base = "/app-content-service/"
        self.pdfUrl = "\(base)\(name).pdf"
        self.svgUrl = "\(base)\(name).svg"
        self.vectorDrawableUrl = "\(base)\(name).xml"
    }
}

extension Icon: Schemable {
    @AppSchemaBuilder static func build() -> AppComponent {
        Type(Icon.self) {
            Field(.pdfUrl, at: \.pdfUrl).description("For iOS use")
            Field(.svgUrl, at: \.svgUrl).description("For Web use")
            Field(.vectorDrawableUrl, at: \.vectorDrawableUrl).description("For Android use")
        }.description("A vectorized image to show to the user")
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

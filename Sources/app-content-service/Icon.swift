//
//  Icon.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-03.
//

import Foundation
import Graphiti
import Vapor

struct IconVariants: Codable, FieldKeyProvider {
    let dark: IconVariant
    let light: IconVariant
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case dark
        case light
    }
    
    init(name: String) {
        self.dark = IconVariant(name: "\(name)_dark")
        self.light = IconVariant(name: name)
    }
}

struct IconVariant: Codable, FieldKeyProvider {
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

struct Icon: Codable, FieldKeyProvider {
    let pdfUrl: String
    let svgUrl: String
    let vectorDrawableUrl: String
    let variants: IconVariants
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case pdfUrl
        case svgUrl
        case vectorDrawableUrl
        case variants
    }
    
    init(name: String) {
        let base = "/app-content-service/"
        self.pdfUrl = "\(base)\(name).pdf"
        self.svgUrl = "\(base)\(name).svg"
        self.vectorDrawableUrl = "\(base)\(name).xml"
        self.variants = IconVariants(name: name)
    }
}

extension Icon: Schemable {
    @AppSchemaBuilder static func build() -> AppComponent {
        Type(IconVariant.self) {
            Field(.pdfUrl, at: \.pdfUrl).description("For iOS use")
            Field(.svgUrl, at: \.svgUrl).description("For Web use")
            Field(.vectorDrawableUrl, at: \.vectorDrawableUrl).description("For Android use")
        }.description("A vectorized image to show to the user")
        Type(IconVariants.self) {
            Field(.dark, at: \.dark).description("A variant to use for dark user interfaces")
            Field(.light, at: \.light).description("A variant to use for light user interfaces")
        }.description("Icons with variants for light and dark mode")
        Type(Icon.self) {
            Field(.pdfUrl, at: \.pdfUrl)
                .description("For iOS use")
                .deprecationReason("Use an icon from a variant instead")
            Field(.svgUrl, at: \.svgUrl)
                .description("For Web use")
                .deprecationReason("Use an icon from a variant instead")
            Field(.vectorDrawableUrl, at: \.vectorDrawableUrl)
                .description("For Android use")
                .deprecationReason("Use an icon from a variant instead")
            Field(.variants, at: \.variants).description("Icons with variants for light and dark mode")
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
    static let whatsNewReward = Icon(name: "whats_new_reward")
    static let whatsNewSpread = Icon(name: "whats_new_spread")
    static let whatsNewKeen = Icon(name: "whats_new_keen")
    static let whatsNewDarkMode = Icon(name: "whats_new_darkmode")
    static let whatsNewEnglish = Icon(name: "whats_new_english")
    static let welcomeBalloons = Icon(name: "welcome_balloons")
    static let welcomeChat = Icon(name: "welcome_chat")
    static let welcomePaid = Icon(name: "welcome_paid")
    static let welcomeReferrals = Icon(name: "welcome_referrals")
}

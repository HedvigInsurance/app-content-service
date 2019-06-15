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

struct BulletPoint: Codable, FieldKeyProvider {
    let icon: Icon
    let title: String
    let description: String
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case icon
        case title
        case description
    }
}

protocol CommonClaimLayouts: Codable {
    var color: HedvigColor { get }
}

struct TitleAndBulletPoints: Codable, CommonClaimLayouts, FieldKeyProvider {
    let color: HedvigColor
    let icon: Icon
    let title: String
    let buttonTitle: String
    let claimFirstMessage: String
    let bulletPoints: [BulletPoint]
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case color
        case icon
        case title
        case buttonTitle
        case claimFirstMessage
        case bulletPoints
    }
}

struct Emergency: Codable, CommonClaimLayouts, FieldKeyProvider {
    let color: HedvigColor
    let title: String
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case color
        case title
    }
}

enum CommonClaimError: Error {
    case parseError
}

struct CommonClaim: Codable, FieldKeyProvider {
    let icon: Icon
    let title: String
    let layout: CommonClaimLayouts
    
    typealias FieldKey = FieldKeys
    
    enum FieldKeys : String {
        case icon
        case title
        case layout
    }
    
    enum CodeKeys: CodingKey
    {
        case icon
        case title
        case layout
    }
    
    init(icon: Icon, title: String, layout: CommonClaimLayouts) {
        self.icon = icon
        self.title = title
        self.layout = layout
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodeKeys.self)
    
        if let emergency = try? container.decode(Emergency.self, forKey: .layout) {
            layout = emergency
        } else if let titleAndBulletPoints = try? container.decode(TitleAndBulletPoints.self, forKey: .layout) {
            layout = titleAndBulletPoints
        } else {
            throw CommonClaimError.parseError
        }
        
        icon = try container.decode(Icon.self, forKey: .icon)
        title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodeKeys.self)
        try container.encode(title, forKey: .title)
        
        if let emergency = layout as? Emergency {
            try container.encode(emergency, forKey: .layout)
        } else if let titleAndBulletPoints = layout as? TitleAndBulletPoints {
            try container.encode(titleAndBulletPoints, forKey: .layout)
        }
        
        try container.encode(icon, forKey: .icon)
    }
}

extension CommonClaim {
    static func delayedLuggage(locale: Localization.Locale) -> CommonClaim {
        return CommonClaim(
            icon: .delayedLuggage,
            title: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_TITLE, locale: locale),
            layout: TitleAndBulletPoints(
                color: .purple,
                icon: .delayedLuggage,
                title: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_LAYOUT_TITLE, locale: locale),
                buttonTitle: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_LAYOUT_BUTTON_TITLE, locale: locale),
                claimFirstMessage: "TODO",
                bulletPoints: [
                    BulletPoint(
                        icon: .compensation,
                        title: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_BULLET_COMPENSATION_TITLE, locale: locale),
                        description: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_BULLET_COMPENSATION_DESCRIPTION, locale: locale)
                    ),
                    BulletPoint(
                        icon: .information,
                        title: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_BULLET_REGARD_TITLE, locale: locale),
                        description: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_BULLET_REGARD_DESCRIPTION, locale: locale)
                    ),
                    BulletPoint(
                        icon: .record,
                        title: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_BULLET_RECORD_TITLE, locale: locale),
                        description: String(key: .COMMON_CLAIM_DELAYED_LUGGAGE_BULLET_RECORD_DESCRIPTION, locale: locale)
                    )
                ]
            )
        )
    }
    
    static func brokenPhone(locale: Localization.Locale) -> CommonClaim {
        return CommonClaim(
            icon: .brokenPhone,
            title: String(key: .COMMON_CLAIM_BROKEN_PHONE_TITLE, locale: locale),
            layout: TitleAndBulletPoints(
                color: .turquoise,
                icon: .brokenPhone,
                title: String(key: .COMMON_CLAIM_BROKEN_PHONE_LAYOUT_TITLE, locale: locale),
                buttonTitle: String(key: .COMMON_CLAIM_BROKEN_PHONE_LAYOUT_BUTTON_TITLE, locale: locale),
                claimFirstMessage: "TODO",
                bulletPoints: [
                    BulletPoint(
                        icon: .compensation,
                        title: String(key: .COMMON_CLAIM_BROKEN_PHONE_BULLET_COMPENSATION_TITLE, locale: locale),
                        description: String(key: .COMMON_CLAIM_BROKEN_PHONE_BULLET_COMPENSATION_DESCRIPTION, locale: locale)
                    ),
                    BulletPoint(
                        icon: .information,
                        title: String(key: .COMMON_CLAIM_BROKEN_PHONE_BULLET_REGARD_TITLE, locale: locale),
                        description: String(key: .COMMON_CLAIM_BROKEN_PHONE_BULLET_REGARD_DESCRIPTION, locale: locale)
                    ),
                    BulletPoint(
                        icon: .record,
                        title: String(key: .COMMON_CLAIM_BROKEN_PHONE_BULLET_RECORD_TITLE, locale: locale),
                        description: String(key: .COMMON_CLAIM_BROKEN_PHONE_BULLET_RECORD_DESCRIPTION, locale: locale)
                    )
                ]
            )
        )
    }
    
    static func emergency(locale: Localization.Locale) -> CommonClaim {
        return CommonClaim(
            icon: .warning,
            title: String(key: .COMMON_CLAIM_EMERGENCY_TITLE, locale: locale),
            layout: Emergency(
                color: .yellow,
                title: String(key: .COMMON_CLAIM_EMERGENCY_LAYOUT_TITLE, locale: locale)
            )
        )
    }
}

extension CommonClaim: Schemable {
    @SchemaBuilder<AppContentAPI, Request> static func build() -> SchemaComponent<AppContentAPI, Request> {
        Type(BulletPoint.self) {
            Field(.title, at: \.title)
            Field(.description, at: \.description)
            Field(.icon, at: \.icon)
        }
        
        Type(TitleAndBulletPoints.self) {
            Field(.color, at: \.color).description("The color to show as the background")
            Field(.icon, at: \.icon)
            Field(.title, at: \.title)
            Field(.buttonTitle, at: \.buttonTitle)
            Field(.claimFirstMessage, at: \.claimFirstMessage)
            Field(.bulletPoints, at: \.bulletPoints)
        }.description("A layout with a title and some bullet points")
        
        Type(Emergency.self) {
            Field(.color, at: \.color)
            Field(.title, at: \.title)
        }.description("The emergency layout shows a few actions for the user to rely on in the case of an emergency")
        
        Union(CommonClaimLayouts.self, members: TitleAndBulletPoints.self, Emergency.self)
        
        Type(CommonClaim.self) {
            Field(.icon, at: \.icon).description("An icon to show on the card of the common claim")
            Field(.title, at: \.title).description("A title to show on the card of the common claim")
            Field(.layout, at: \.layout).description(
                "The layout to use for the subpage regarding the common claim"
            )
        }.description("A list of claim types that are common to show for the user")
    }
}

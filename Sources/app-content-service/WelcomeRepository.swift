//
//  WelcomeRepository.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-06-28.
//

import Foundation

struct WelcomeRepository {
    static func find( platform: Platform, locale: Localization.Locale) -> [Welcome] {
        if (platform == .Android) {
            return Welcome.androidWelcome(locale: locale)
        } else if (platform == .iOS) {
            return Welcome.iOSWelcome(locale: locale)
        }
        return []
    }
    
}

extension Welcome {
    static func iOSWelcome(locale: Localization.Locale) -> [Welcome] {
        return [Welcome.referrals(locale: locale)]
    }
    
    static func androidWelcome(locale: Localization.Locale) -> [Welcome] {
        return [Welcome.referrals(locale: locale)]
    }
    
    static func referrals(locale: Localization.Locale) -> Welcome {
        return Welcome(
            illustration: Icon.bonusRain,
            title: String(key: .NEWS_REFERRALS_HEADLINE, locale: locale),
            paragraph: String(key: .NEWS_REFERRALS_BODY, locale: locale)
        )
    }
}

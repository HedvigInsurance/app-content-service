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
        return [
            Welcome.welcome(locale: locale),
            Welcome.chat(locale: locale),
            Welcome.paid(locale: locale),
            Welcome.referrals(locale: locale)
        ]
    }
    
    static func androidWelcome(locale: Localization.Locale) -> [Welcome] {
        return [
            Welcome.welcome(locale: locale),
            Welcome.chat(locale: locale),
            Welcome.paid(locale: locale),
            Welcome.referrals(locale: locale)
        ]
    }
    
    static func welcome(locale: Localization.Locale) -> Welcome {
        return Welcome(
            illustration: Icon.welcomeBalloons,
            title: String(key: .NEW_MEMBER_WELCOME_TITLE, locale: locale),
            paragraph: String(key: .NEW_MEMBER_WELCOME_BODY, locale: locale)
        )
    }
    
    static func chat(locale: Localization.Locale) -> Welcome {
        return Welcome(
            illustration: Icon.welcomeChat,
            title: String(key: .NEW_MEMBER_CHAT_TITLE, locale: locale),
            paragraph: String(key: .NEW_MEMBER_CHAT_BODY, locale: locale)
        )
    }
    
    static func paid(locale: Localization.Locale) -> Welcome {
        return Welcome(
            illustration: Icon.welcomePaid,
            title: String(key: .NEW_MEMBER_CLAIMS_TITLE, locale: locale),
            paragraph: String(key: .NEW_MEMBER_CLAIMS_BODY, locale: locale)
        )
    }
    
    static func referrals(locale: Localization.Locale) -> Welcome {
        return Welcome(
            illustration: Icon.welcomeReferrals,
            title: String(key: .NEW_MEMBER_REFERRALS_TITLE, locale: locale),
            paragraph: String(key: .NEW_MEMBER_REFERRALS_BODY, locale: locale)
        )
    }
}

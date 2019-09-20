//
//  NewsRepository.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-28.
//

import Foundation

struct NewsRepository {
    static func findSince(version: SemVer, platform: Platform, locale: Localization.Locale) -> [News] {
        if (platform == .Android) {
            return NewsRepository.findIn(newsCollection: News.androidNews(locale: locale), version: version)
        }
        if (platform == .iOS) {
            return NewsRepository.findIn(newsCollection: News.iOSNews(locale: locale), version: version)
        }
        return []
    }
    
    static func findIn(newsCollection: [(SemVer, [News])], version: SemVer) -> [News] {
        return newsCollection
            .filter { (v, _) -> Bool in
                if (v.major > version.major) {
                    return true
                }
                if (v.major == version.major && v.minor > version.minor) {
                    return true
                }
                if (v.major == version.major && v.minor == version.minor && v.patch > version.patch) {
                    return true
                }
                return false
            }.flatMap { (_, news) in
                return news
            }
    }
}

extension News {
    static func iOSNews(locale: Localization.Locale) -> [(SemVer, [News])] {
        return [
            (
                SemVer(major: 2, minor: 9, patch: 0),
                [
                    News.referralsReward(locale: locale),
                    News.referralsSpread(locale: locale),
                    News.referralsKeen(locale: locale)
                ]
            ),
            (
                SemVer(major: 3, minor: 0, patch: 0),
                [
                    News.darkMode(locale: locale),
                    locale == .en_SE ? News.englishSupport(locale: locale) : nil,
                ].compactMap { $0 }
            )
        ]
    }
    
    static func androidNews(locale: Localization.Locale) -> [(SemVer, [News])] {
        return [
            (
                SemVer(major: 2, minor: 9, patch: 0),
                [
                    News.referralsReward(locale: locale),
                    News.referralsSpread(locale: locale),
                    News.referralsKeen(locale: locale)
                ]
            )
        ]
    }
    
    static func referralsReward(locale: Localization.Locale) -> News {
        return News(
            illustration: Icon.whatsNewReward,
            title: String(key: .NEWS_REFERRALS_REWARD_MEMBERS_TITLE, locale: locale),
            paragraph: String(key: .NEWS_REFERRALS_REWARD_MEMBERS_BODY, locale: locale)
        )
    }
    
    static func referralsSpread(locale: Localization.Locale) -> News {
        return News(
            illustration: Icon.whatsNewSpread,
            title: String(key: .NEWS_REFERRALS_SHARE_LINK_TITLE, locale: locale),
            paragraph: String(key: .NEWS_REFERRALS_SHARE_LINK_BODY, locale: locale)
        )
    }
    
    static func referralsKeen(locale: Localization.Locale) -> News {
        return News(
            illustration: Icon.whatsNewKeen,
            title: String(key: .NEWS_REFERRALS_APP_TITLE, locale: locale),
            paragraph: String(key: .NEWS_REFERRALS_APP_BODY, locale: locale)
        )
    }
    
    static func englishSupport(locale: Localization.Locale) -> News {
        return News(
            illustration: Icon.whatsNewEnglish,
            title: String(key: .NEWS_ENGLISH_APP_TITLE, locale: locale),
            paragraph: String(key: .NEWS_ENGLISH_APP_BODY, locale: locale)
        )
    }
    
    static func darkMode(locale: Localization.Locale) -> News {
        return News(
            illustration: Icon.whatsNewDarkMode,
            title: String(key: .NEWS_DARKMODE_APP_TITLE, locale: locale),
            paragraph: String(key: .NEWS_DARKMODE_APP_BODY, locale: locale)
        )
    }
}

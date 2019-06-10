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
                [News.referrals(locale: locale)]
            )
        ]
    }
    
    static func androidNews(locale: Localization.Locale) -> [(SemVer, [News])] {
        return [
            (
                SemVer(major: 2, minor: 9, patch: 0),
                [News.referrals(locale: locale)]
            )
        ]
    }
    
    static func referrals(locale: Localization.Locale) -> News {
        return News(
            illustration: Icon.bonusRain,
            title: String(key: .NEWS_REFERRALS_HEADLINE, locale: locale),
            paragraph: String(key: .NEWS_REFERRALS_BODY, locale: locale)
        )
    }
}

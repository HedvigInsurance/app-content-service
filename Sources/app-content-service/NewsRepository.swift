//
//  NewsRepository.swift
//  app-content-service
//
//  Created by Oscar Nylander on 2019-05-28.
//

import Foundation

enum SemVerError: Error {
    case parse
}

struct SemVer {
    let major: Int
    let minor: Int
    let patch: Int
    
    static func parse(version: String) throws -> SemVer {
        let parts = version.split(separator: ".")

        
        guard let major = Int(String(parts[0])),
            let minor = Int(String(parts[1])),
            let patch = Int(String(parts[2])) else {
            throw SemVerError.parse
        }
        
        return SemVer(
            major: major,
            minor: minor,
            patch: patch
        )
    }
}

struct NewsRepository {
    static func findSince(version: SemVer, platform: Platform) -> [News] {
        if (platform == .Android) {
            return NewsRepository.findIn(newsCollection: News.androidNews, version: version)
        }
        if (platform == .iOS) {
            return NewsRepository.findIn(newsCollection: News.iOSNews, version: version)
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
            }.flatMap { (_, news) -> [News] in
                return news
        }
    }
}

extension News {
    static let iOSNews = [
        (
            SemVer(major: 2, minor: 9, patch: 0),
            [News.referrals]
        )
    ]
    
    static let androidNews = [
        (
            SemVer(major: 2, minor: 9, patch: 0),
            [News.referrals]
        )
    ]
    
    static let referrals = News(
        illustration: Icon.moneyRain,
        title: "NEWS_REFERRALS_TITLE", // TODO remake this obviously
        paragraph: "NEWS_REFERRALS_PARAGRAPH"
    )
}

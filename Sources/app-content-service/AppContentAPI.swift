//
//  AppContentAPI.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-06-11.
//

import Foundation
import Graphiti
import Vapor

struct AppContentAPI: FieldKeyProvider {
    typealias FieldKey = FieldKeys
    
    enum FieldKeys: String {
        case commonClaims
        case news
        case welcome
    }
    
    struct CommonClaimArguments: Codable {
        let locale: Localization.Locale
    }
    
    func getCommonClaims(request: Request, arguments: CommonClaimArguments) -> [CommonClaim] {
        let commonClaims = [
            CommonClaim.emergency(locale: arguments.locale),
            CommonClaim.delayedLuggage(locale: arguments.locale),
            CommonClaim.brokenPhone(locale: arguments.locale)
        ]
        
        return commonClaims
    }
    
    struct NewsArguments: Codable {
        let platform: Platform
        let sinceVersion: String
        let locale: Localization.Locale
    }
    
    func getNews(request: Request, arguments: NewsArguments) -> [News] {
        return NewsRepository.findSince(
            version: SemVer.parse(version: arguments.sinceVersion),
            platform: arguments.platform,
            locale: arguments.locale
        )
    }
    
    struct WelcomeArguments: Codable {
        let platform: Platform
        let locale: Localization.Locale
    }
    
    func getWelcome(request: Request, arguments: WelcomeArguments) -> [Welcome] {
        return WelcomeRepository.find(
            platform: arguments.platform,
            locale: arguments.locale
        )
    }
}

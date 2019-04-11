//
//  TranslationsRepo.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-10.
//

import Foundation

// Todo write some logic for fetching translations from backend
struct TranslationsRepo {
    static func find(_ key: Localization.Key) -> String? {
        return nil
    }
    
    static func findWithReplacements(_ key: Localization.Key, replacements: [String: String]) -> String? {
        return nil
    }
}

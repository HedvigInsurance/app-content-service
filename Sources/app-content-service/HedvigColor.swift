//
//  HedvigColor.swift
//  app-content-service
//
//  Created by Sam Pettersson on 2019-04-11.
//

import Foundation
import GraphQL
import Graphiti
import Vapor

enum HedvigColor: String, Codable, CaseIterable {
    case pink = "Pink"
    case turquoise = "Turquoise"
    case purple = "Purple"
    case darkPurple = "DarkPurple"
    case blackPurple = "BlackPurple"
    case darkGray = "DarkGray"
    case lightGray = "LightGray"
    case white = "White"
    case black = "Black"
    case offBlack = "OffBlack"
    case offWhite = "OffWhite"
    case yellow = "Yellow"
}


extension HedvigColor: Schemable {
    @SchemaBuilder<AppContentAPI, Request> static func build() -> SchemaComponent<AppContentAPI, Request> {
        Enum(HedvigColor.self) {
            Value(.pink)
            Value(.turquoise)
            Value(.purple)
            Value(.darkPurple)
            Value(.blackPurple)
            Value(.darkGray)
            Value(.lightGray)
            Value(.white)
            Value(.black)
            Value(.offBlack)
            Value(.offWhite)
            Value(.yellow)
        }
    }
}

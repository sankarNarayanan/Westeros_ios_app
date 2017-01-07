//
//  File.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 15/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import Foundation

struct AppConstants {

    static let baseUrl = "http://starlord.hackerearth.com/gotjson"
    static let httpGetMethod = "GET"
    static let httpPostMethod = "POST"
    
}


struct jsonResponseConstants {
    static let name = "name"
    static let year = "year"
    static let battleNumber = "battle_number"
    static let attackerKing = "attacker_king"
    static let defenderKing = "defender_king"
    static let attacker1 = "attacker_1"
    static let attacker2 = "attacker_2"
    static let attacker3 = "attacker_3"
    static let attacker4 = "attacker_4"
    static let defender1 = "defender_1"
    static let defender2 = "defender_2"
    static let defender3 = "defender_3"
    static let defender4 = "defender_4"
    static let attackerOutcome = "attacker_outcome"
    static let battleType = "battle_type"
    static let majorDeath = "major_death"
    static let majorCapture = "major_capture"
    static let attackerSize = "attacker_size"
    static let defenderSize = "defender_size"
    static let attackerCommander = "attacker_commander"
    static let defenderCommander = "defender_commander"
    static let summer = "summer"
    static let location = "location"
    static let region = "region"
    static let note = "note"
}


struct coreDataBaseConstants{
    static let battleTableName = "Battle"
    static let attckerKing = "attckerKing"
    static let defenderKing = "defenderKing"
    static let kingName = "kingName"
    static let kingTableName = "King"
    static let winnerKey = "winner"
}

struct colorConstants{
    static let themeBlue = "#2AAAE3"
    static let themeVariantDarkBlue = "#278AE5"
}



struct FontAwesomeCodes {
    static let backIcon = "\u{f104}"
}


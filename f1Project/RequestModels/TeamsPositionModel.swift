//
//  TeamsPositionModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 24.03.2022.
//

import Foundation

public struct TeamStandings: Codable {
    let data: TeamStandingsData

    enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

struct TeamStandingsData: Codable {
    let standingsTable: TeamStandingsTable

    enum CodingKeys: String, CodingKey {
        case standingsTable = "StandingsTable"
    }
}


struct TeamStandingsTable: Codable {
    
    let standingList: [TeamStandingsLists]
    
    enum CodingKeys: String, CodingKey {
        case standingList = "StandingsLists"
    }
}

struct TeamStandingsLists: Codable {
    
    let teamStanding: [TeamStanding]
    let season: String
    enum CodingKeys: String, CodingKey {
        case season
        case teamStanding = "ConstructorStandings"
    }
}


struct TeamStanding: Codable {
    
    let position: String
    let points: String
    let wins: String
    let constructor: Constructor
    enum CodingKeys: String, CodingKey {
        case points
        case position
        case wins
        case constructor = "Constructor"
    }
}



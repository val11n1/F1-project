//
//  PositionModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import Foundation



public struct DriverStandings: Codable {
    let data: DriverStandingsData

    enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

struct DriverStandingsData: Codable {
    let standingsTable: StandingsTable

    enum CodingKeys: String, CodingKey {
        case standingsTable = "StandingsTable"
    }
}


struct StandingsTable: Codable {
    
    let standingList: [StandingsLists]
    
    enum CodingKeys: String, CodingKey {
        case standingList = "StandingsLists"
    }
}

struct StandingsLists: Codable {
    
    let driverStanding: [DriverStanding]
    let season: String
    enum CodingKeys: String, CodingKey {
        case season
        case driverStanding = "DriverStandings"
    }
}


struct DriverStanding: Codable {
    
    let position: String
    let points: String
    let driver: Driver
    let constructors: [Constructor]
    enum CodingKeys: String, CodingKey {
        case points
        case position
        case driver = "Driver"
        case constructors = "Constructors"
    }
}

struct Driver: Codable {
    
    let givenName: String
    let familyName: String
    let permanentNumber: String
    let driverId: String
    let nationality: String
}


struct Constructor: Codable {
    
    let name: String
}



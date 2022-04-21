//
//  RaceResultModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 07.04.2022.
//

import Foundation


struct RaceResultModel: Codable {
    
    let data: RaceResultData
    
    enum CodingKeys: String, CodingKey {
        
        case data = "MRData"
    }
}

struct RaceResultData: Codable {
    
    let table: RaceTableResult
    let limit: String
    enum CodingKeys: String, CodingKey {
        
        case table = "RaceTable"
        case limit = "limit"
    }
}

struct RaceTableResult: Codable {

    let races: [RacesResult]
    let season: String
    enum CodingKeys: String, CodingKey {
        case season = "season"
        case races = "Races"
    }
}

struct RacesResult: Codable {

    let result: [Results]

    enum CodingKeys: String, CodingKey {

        case result = "Results"
    }
}

struct Results: Codable {
    
    let position: String
    let points: String
    let grid: String
    let status: String
    let constructor: Constructor
    let driver: Driver
    let time: Time?
    let fastesLap: FastestLap?

    enum CodingKeys: String, CodingKey {
        case points = "points"
        case position = "position"
        case constructor = "Constructor"
        case driver = "Driver"
        case grid = "grid"
        case status = "status"
        case time = "Time"
        case fastesLap = "FastestLap"
    }
}

struct AverageSpeed: Codable {
    
    let speed: String
}

struct Time: Codable {
    
    let time: String
}

struct FastestLap: Codable {
    
    let rank: String
    let lap: String
    let time: Time
    let avgSpeed: AverageSpeed
    
    enum CodingKeys: String, CodingKey {
        case avgSpeed = "AverageSpeed"
        case rank = "rank"
        case lap = "lap"
        case time = "Time"
    }
}

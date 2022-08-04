//
//  ScheduleModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 31.03.2022.
//

import Foundation


struct RacesSchedule: Codable {
    
    let data: ScheduleData
    
    enum CodingKeys: String, CodingKey {
        
       case data = "MRData"
    }
}


struct ScheduleData: Codable {
    
    let raceTable: RaceTable
    
    enum CodingKeys: String, CodingKey {
        
       case raceTable = "RaceTable"
    }
}

struct RaceTable: Codable {
    
    let races: [Race]
    
    enum CodingKeys: String, CodingKey {
        
       case races = "Races"
    }
}

struct Race: Codable {
    
    let round: String
    let raceName: String
    let circuit: Circuit
    let date: String
    let time: String
    let firstPractice: FirstPractice
    let secondPractice: SecondPractice
    let thirdPractice: ThirdPractice?
    let qualifying: Qualifying
    let sprint: Sprint?
    
    enum CodingKeys: String, CodingKey {
        
        case round = "round"
        case raceName = "raceName"
        case circuit = "Circuit"
        case date = "date"
        case time = "time"
        case firstPractice = "FirstPractice"
        case secondPractice = "SecondPractice"
        case thirdPractice = "ThirdPractice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
    }
}

struct Circuit: Codable {
    
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        
        case location = "Location"
    }
}

struct Location: Codable {
    
    let locality: String
    let country: String
}

struct FirstPractice: RaceEvent {
    
    let date: String
    let time: String
}

struct SecondPractice: RaceEvent {
    
    let date: String
    let time: String
}

struct ThirdPractice: RaceEvent {
    
    let date: String
    let time: String
}

struct Qualifying: RaceEvent {
    
    let date: String
    let time: String
}

struct Sprint: RaceEvent {
    
    let date: String
    let time: String
}

struct Event: RaceEvent {
    
    let date: String
    let time: String
}

protocol RaceEvent: Codable {
    var date: String {get}
    var time: String {get}
}



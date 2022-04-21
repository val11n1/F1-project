//
//  RaceResult.swift
//  f1Project
//
//  Created by Valeriy Trusov on 07.04.2022.
//

import Foundation


struct RaceResult {
    
    let position: String
    let points: String
    let qualifyingPosition: String
    let finishStatus: String
    let constructorName: String
    let driverFirstName: String
    let driverLastName: String
    var raceTime: String?
    var fastesLapTime: String?
    var fastesLapNumber: String?
    var fastesLapRank: String?
    var fastesLapAvrSpeed: String?
}

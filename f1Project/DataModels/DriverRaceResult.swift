//
//  DriverRaceResult.swift
//  f1Project
//
//  Created by Valeriy Trusov on 07.04.2022.
//

import Foundation


struct DriverRaceResult: ModelProtocol {
    
    
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
    
    static func createRaceResultArray(driverRaceResult: RaceResultModel) -> [DriverRaceResult] {
        
        var raceResultArray = [DriverRaceResult]()
        guard let array = driverRaceResult.data.table.races.first?.result,
        array.count > 0 else { return raceResultArray }
        
        for race in driverRaceResult.data.table.races.first!.result {
            
            var raceResult = DriverRaceResult(position: race.position, points: race.points, qualifyingPosition: race.grid, finishStatus: race.status, constructorName: race.constructor.name, driverFirstName: race.driver.givenName, driverLastName: race.driver.familyName, raceTime: nil, fastesLapTime: nil, fastesLapNumber: nil, fastesLapRank: nil, fastesLapAvrSpeed: nil)
            
            if let time = race.time {
                
                raceResult.raceTime = time.time
                
            }else if race.status.contains("Lap") {
                
                raceResult.raceTime = race.status
            }
            
            if let fastesLap = race.fastesLap {
                
                raceResult.fastesLapTime = fastesLap.time.time
                raceResult.fastesLapRank = fastesLap.rank
                raceResult.fastesLapNumber = fastesLap.lap
                raceResult.fastesLapAvrSpeed = fastesLap.avgSpeed.speed
            }
            
            raceResultArray.append(raceResult)
        }
        return raceResultArray
    }
}

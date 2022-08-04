//
//  DriverModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import Foundation


struct DriverModel: ModelProtocol {
    
    
    let firstName: String
    let lastName: String
    let points: String
    let position: String
    let teamName: String
    let permanentNumber: String
    let driverId: String
    let nationality: String
    
    
    static func createDriverModelArray(driversStandings: DriverStandings) -> [DriverModel] {
        
        var driversArray = [DriverModel]()
        
        for driverStanding in driversStandings.data.standingsTable.standingList.first!.driverStanding {
            
            let position = driverStanding.position
            let points = driverStanding.points
            let firstName = driverStanding.driver.givenName
            let lastName = driverStanding.driver.familyName
            let number = driverStanding.driver.permanentNumber
            let teamName = driverStanding.constructors.first?.name
            let id = driverStanding.driver.driverId
            let nationality = driverStanding.driver.nationality
            
            let driverModel = DriverModel(firstName: firstName, lastName: lastName, points: points, position: position, teamName: teamName!, permanentNumber: number, driverId: id, nationality: nationality)
            
            
            driversArray.append(driverModel)
        }
        
        return driversArray
    }
}

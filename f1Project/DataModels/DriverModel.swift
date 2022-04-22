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
    
    
    static func createDriverModelArray(data: Data) -> [DriverModel] {
         
        let decoder = JSONDecoder()
        var driversArray = [DriverModel]()

        do {
            let drivers = try decoder.decode(DriverStandings.self, from: data)
            let standingList = drivers.data.standingsTable.standingList.first
            
            
            for driverStanding in standingList!.driverStanding {
                
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
            
           
            
        } catch let err {
            print(err)
            
        }
        return driversArray
     }
}

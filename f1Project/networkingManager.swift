//
//  networkingManager.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import Foundation


class networkingManager {
    
    var RaceInfoTask: URLSessionDataTask!
    static let shared = networkingManager()
    
    init() {
        
        
    }
   
    
     func fetchCurrentDriverStanding(URLString: String, completionHandler: @escaping ([Any]?) -> Void)  {
        
        
        guard let url = URL(string: URLString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, responce, error in
            
            //                let s = String(data: data, encoding: .utf8)
            //                print(s)
            
            if let data = data {
                
                if URLString.contains("constructor") {

                    let array = self.teamsStandingParcerJSON(withData: data)
                   completionHandler(array!)

                }else {

                    let array = self.driversStandingParcerJSON(withData: data)
                   completionHandler(array!)
                }

            }else {

                print("\(String(describing: error?.localizedDescription))")
            }
        }
        task.resume()
        
    }

    
    //MARK: Parsing JSON
    

    private func driversStandingParcerJSON(withData data: Data) -> [DriverModel]? {
    
    let decoder = JSONDecoder()

    do {
        //let drivers = try decoder.decode(TeamStandings.self, from: data)
        let drivers = try decoder.decode(DriverStandings.self, from: data)
        let standingList = drivers.data.standingsTable.standingList.first
        
        var driversArray = [DriverModel]()
        
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
        
        return driversArray
        
    } catch let err {
        print(err)
        return nil
    }
}
    
    private func teamsStandingParcerJSON(withData data: Data) -> [TeamModel]? {
    
    let decoder = JSONDecoder()

    do {
        let teams = try decoder.decode(TeamStandings.self, from: data)
        let standingList = teams.data.standingsTable.standingList.first
        
        var teamssArray = [TeamModel]()
        
        for teamStanding in standingList!.teamStanding {
            
            let position = teamStanding.position
            let points = teamStanding.points
            let name = teamStanding.constructor.name
            let wins = teamStanding.wins
            
            let teamModel = TeamModel(name: name, position: position, points: points, wins: wins)
            
            teamssArray.append(teamModel)
        }
        
        return teamssArray
        
    } catch let err {
        print(err)
        return nil
    }
}
    
    func fetchSchedule( completionHandler: @escaping ([RaceModel]?) -> Void) {
        
        
        let URLString = "http://ergast.com/api/f1/current.JSON"
        
        guard let url = URL(string: URLString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {[unowned self] data, responce, error in
            
            if let data = data {

                let array = raceScheduleJSONParcing(data: data)
                completionHandler(array.count == 0 ? nil: array)
            }
        }
        task.resume()
    }
    
    
    
    private func raceScheduleJSONParcing(data: Data) -> [RaceModel] {
        
        let decoder = JSONDecoder()
        
        var racesArray = [RaceModel]()

        do {
            let schedule = try decoder.decode(ScheduleStruct.self, from: data)
            let racesList = schedule.data.raceTable.races
            
            for race in racesList{
                
                let raceName = race.raceName
                let round = race.round
                let country = race.circuit.location.country
                let locality = race.circuit.location.locality
                let date = race.date
                
                
                let stringIndex = race.time.index(race.time.startIndex, offsetBy: 5)
                let raceTime = race.time[..<stringIndex]
                
                let fpTime = race.firstPractice.time[..<stringIndex]
                let spTime = race.secondPractice.time[..<stringIndex]
                let qualifyingTime = race.qualifying.time[..<stringIndex]
                
                let firstPractice = FirstPractice(date: race.firstPractice.date, time: String(fpTime))
                let sp = SecondPractice(date: race.secondPractice.date, time: String(spTime))
                let qualifying = Qualifying(date: race.qualifying.date, time: String(qualifyingTime))

                var raceModel = RaceModel(name: raceName, round: round, country: country, locality: locality, date: date, time: String(raceTime), firstPractice: firstPractice, secondPractice: sp, thirdPractice: nil, qualifying:qualifying, sprint: nil)
                
                if let tp = race.thirdPractice {
                    let tpTime = race.thirdPractice!.time[..<stringIndex]
                    raceModel.thirdPractice = ThirdPractice(date: tp.date, time: String(tpTime))
                    
                }
                
                if let sprint = race.sprint {
                    let sprintTime = race.sprint!.time[..<stringIndex]
                    raceModel.sprint = Sprint(date: sprint.date, time: String(sprintTime))
                }
                
                racesArray.append(raceModel)
            }
           
            
        } catch let err {
            print(err)
            
        }
        
        return racesArray
    }
    
    
    
    func fetchRaceResult(round: Int, completionHandler: @escaping ([RaceResult]?) -> Void) {
        
        let date = Date()
        let calendar = Calendar.current
        let component = calendar.component(.year, from: date)
        
        let URLString = "http://ergast.com/api/f1/\(component)/\(round)/results.json"
        
        guard let url = URL(string: URLString) else { return }
        
        let session = URLSession(configuration: .default)
        RaceInfoTask = session.dataTask(with: url) { [unowned self] data, responce, error in
            
            if let data = data {
                
//                                let s = String(data: data, encoding: .utf8)
//                                print(s)
                
                let array = raceResultJSONParcing(data: data)
                completionHandler(array.count == 0 ? nil: array)
            }
        }
        RaceInfoTask.resume()
    }
    
    
    private func raceResultJSONParcing(data: Data) -> [RaceResult] {
        
        let decoder = JSONDecoder()
print("huy")
        var raceResultArray = [RaceResult]()
        
        do {
            let raceData = try decoder.decode(RaceResultModel.self, from: data)
            let arrayResults = raceData.data.table.races.first
            
            
            if let racesResults = arrayResults?.result {
                
                for race in racesResults {
                    
                    var raceResult = RaceResult(position: race.position, points: race.points, qualifyingPosition: race.grid, finishStatus: race.status, constructorName: race.constructor.name, driverFirstName: race.driver.givenName, driverLastName: race.driver.familyName, raceTime: nil, fastesLapTime: nil, fastesLapNumber: nil, fastesLapRank: nil, fastesLapAvrSpeed: nil)
                    
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
            }
            
        }catch let err {
            
            //print(err.localizedDescription)
            print(String(describing: err))
        }
        
        return raceResultArray
    }
    
  
}

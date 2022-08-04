//
//  RaceModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 01.04.2022.
//

import Foundation



struct RaceModel: ModelProtocol {
    
    
    let name: String
    let round: String
    let country: String
    let locality: String
    let date: String
    let time: String
    let firstPractice: FirstPractice
    let secondPractice: SecondPractice
    var thirdPractice: ThirdPractice?
    let qualifying: Qualifying
    var sprint: Sprint?
    
    enum RaceEvent {
        
        case firstPractice
        case secondPractice
        case qualifying
        case race
        case thirdPracticeOrSprint
        case raceInProgress
        case raceHasPassed
    }
    
    func raceDateWithOffset() -> Date {
       return dateFromRaceModel(date: date, time: time) + 60 * 60 * 5
    }
    
    func dateFromEvent(event: RaceEvent) -> Date {
        
        var date = String()
        var time = String()
        
        switch event {
        case .firstPractice:
            date = firstPractice.date
            time = firstPractice.time
        case .secondPractice:
            date = secondPractice.date
            time = secondPractice.time
        case .qualifying:
            date = qualifying.date
            time = qualifying.time
        case .race:
            date = self.date
            time = self.time
        case .thirdPracticeOrSprint:
            if self.thirdPractice != nil {
                
                date = thirdPractice!.date
                time = thirdPractice!.time
            }else {
                
                date = sprint!.date
                time = sprint!.time
            }
        case .raceInProgress: return Date().returnCurrentDate()
        case .raceHasPassed: return Date().returnCurrentDate()
        }
        
        return dateFromRaceModel(date: date, time: time)
    }
    
    private func dateFromRaceModel(date: String, time: String) -> Date {
        
        let GMTSeconds = TimeInterval(TimeZone.current.secondsFromGMT())
        
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        dateFormatter.dateFormat = "HH:mm"
        let raceTime = dateFormatter.date(from: time)!.addingTimeInterval(GMTSeconds)
        
        dateFormatter.dateFormat = "yyyy-MM-dd/"
        let raceDate = dateFormatter.date(from: date)!.addingTimeInterval(GMTSeconds)
        
        let raceTimeComponents = calendar.dateComponents([.hour, .minute], from: raceTime)
        let raceDateComponents = calendar.dateComponents([.year, .month, .day], from: raceDate)
        
        let raceDateFromComponents = DateComponents(calendar: calendar,year: raceDateComponents.year, month: raceDateComponents.month, day: raceDateComponents.day, hour: raceTimeComponents.hour, minute: raceTimeComponents.minute)
        
        return calendar.date(from: raceDateFromComponents)!.addingTimeInterval(TimeInterval(GMTSeconds))
    }
    
    static func createRaceModelArray(racesSchedule: RacesSchedule) -> [RaceModel] {
        
        var racesArray = [RaceModel]()
        
        for race in racesSchedule.data.raceTable.races {
            
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
        return racesArray
    }
    
    func nextUpcomingEvent() -> RaceModel.RaceEvent {
        
        let dateNow = Date().returnCurrentDate()
        
        var event: RaceModel.RaceEvent!

        if self.thirdPractice != nil {
        
        switch true {
        case _ where self.dateFromEvent(event: .firstPractice) > dateNow:
            event = .firstPractice
        case _ where self.dateFromEvent(event: .secondPractice) > dateNow:
            event = .secondPractice
        case _ where self.dateFromEvent(event: .thirdPracticeOrSprint) > dateNow:
            event = .thirdPracticeOrSprint
        case _ where self.dateFromEvent(event: .qualifying) > dateNow:
            event = .qualifying
        case _ where self.dateFromEvent(event: .race) > dateNow:
            event = .race
        case _ where self.dateFromEvent(event: .race) < dateNow && dateNow < self.raceDateWithOffset():
            event = .raceInProgress
        case _ where dateNow > self.raceDateWithOffset():
            event = .raceHasPassed
        default: break
        }

    }else {
        
        switch true {
        case _ where self.dateFromEvent(event: .firstPractice) > dateNow:
            event = .firstPractice
        case _ where self.dateFromEvent(event: .qualifying) > dateNow:
            event = .qualifying
        case _ where self.dateFromEvent(event: .secondPractice) > dateNow:
            event = .secondPractice
        case _ where self.dateFromEvent(event: .thirdPracticeOrSprint) > dateNow:
            event = .thirdPracticeOrSprint
        case _ where self.dateFromEvent(event: .race) > dateNow:
            event = .race
        case _ where self.dateFromEvent(event: .race) < dateNow && dateNow < self.raceDateWithOffset():
            event = .raceInProgress
        case _ where dateNow > self.raceDateWithOffset():
            event = .raceHasPassed
        default: break
        }
    }
        return event
    }
}


extension RaceModel: Equatable {
    
    static func == (lhs: RaceModel, rhs: RaceModel) -> Bool {
        
        return lhs.name == rhs.name && lhs.round == rhs.round
    }
}

//
//  RaceModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 01.04.2022.
//

import Foundation



struct RaceModel {
    
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
        }
        
        return dateFromRaceModel(date: date, time: time)
    }
    
    func dateFromRaceModel(date: String, time: String) -> Date {
        
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
}

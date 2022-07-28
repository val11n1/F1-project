//
//  ScheduleViewModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 28.07.2022.
//

import Foundation
import UIKit

enum TypeOfRace {
    
    case nextRace
    case upcomingRace
    case pastRace
}

class ScheduleViewModel: ScheduleViewModelProtocol {
    
    private var upcomingRacesArray: [RaceModel]?
    private var pastRacesArray: [RaceModel]?
    
    private init(upcomingArray: [RaceModel], pastArray: [RaceModel]) {
        self.upcomingRacesArray = upcomingArray
        self.pastRacesArray = pastArray
        
    }
    
    init() {
        
    }

    
    static func createViewModel(completion: @escaping (ScheduleViewModelProtocol) -> ()) {
        
        let queue = DispatchQueue(label: "queueForSchedule", qos: .userInitiated)
        
        queue.async {
            
            networkingManager.shared.fetchData(type: .RaceScheduleResponce, round: nil) { array in
                if let fetchedArray = array as? [RaceModel] {
                    
                    var pastArray = [RaceModel]()
                    var upcomingArray = [RaceModel]()
                    
                    let date = Date().returnCurrentDate()
                    
                    for race in fetchedArray {
                        
                        if race.raceDateWithOffset() < date {
                            
                            pastArray.append(race)
                        }else {
                            
                            upcomingArray.append(race)
                        }
                    }
                    
                    completion(ScheduleViewModel(upcomingArray: upcomingArray, pastArray: pastArray))
                    
                }else {
                    completion(ScheduleViewModel())
                }
            }
        }
    }
    
    func viewModelHaveUpcomingRacesData() -> Bool {
        
        if let upcomingRacesArray = upcomingRacesArray {
            return upcomingRacesArray.count > 0 ? true: false
        }
        return false
    }
    
    func nextUpcomingRace() -> RaceModel {
        return upcomingRacesArray![0]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if let upcomingRacesArray = upcomingRacesArray, let pastRacesArray = pastRacesArray {
            
            switch section {
            case 0: return upcomingRacesArray.count
            case 1: return pastRacesArray.count
            default: return 0
            }
        }
        
        return 0
    }
    
    func heightForRowAt() -> CGFloat {
        return 90.0
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        
        switch section {
        case 0: return "Upcoming races"
        case 1: return "Past races"
        default: return nil
        }
    }
    
    func raceModelFrom(indexPath: IndexPath) -> RaceModel? {
        
        switch indexPath.section {
        case 0: return upcomingRacesArray![indexPath.row]
        case 1: return pastRacesArray![indexPath.row]
        default: return nil
        }
    }
    
    func typeOf(race: RaceModel) -> TypeOfRace {
        
        if race == nextUpcomingRace() {
            return TypeOfRace.nextRace
        }
        
        if race.raceDateWithOffset() < Date().returnCurrentDate() {
            return .pastRace
        }else {
            return.upcomingRace
        }
    }
    
}

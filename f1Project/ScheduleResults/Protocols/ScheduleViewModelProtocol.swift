//
//  ScheduleViewModelProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 28.07.2022.
//

import Foundation
import UIKit


protocol ScheduleViewModelProtocol {
    
    static func createViewModel(completion: @escaping (ScheduleViewModelProtocol?) -> ())
    func viewModelHaveUpcomingRacesData() -> Bool
    func nextUpcomingRace() -> RaceModel?
    func numberOfRowsInSection(section: Int) -> Int
    func heightForRowAt() -> CGFloat
    func numberOfSections() -> Int
    func titleForHeaderInSection(section: Int) -> String?
    func raceModelFrom(indexPath: IndexPath) -> RaceModel?
    func typeOf(race: RaceModel) -> TypeOfRace
    func nextUpcomingRaceToPastRaces()
}

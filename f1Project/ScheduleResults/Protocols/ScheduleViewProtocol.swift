//
//  ScheduleViewProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 28.07.2022.
//

import Foundation
import UIKit


protocol ScheduleViewProtocol {
    
    var raceCellId: String { get }
    var raceHeaderFooterId: String { get }
    var activityIndicator: UIActivityIndicatorView { get }
    var tableView: UITableView { get }
    
    func nextEventDescritionFrom(race: RaceModel, event: RaceModel.RaceEvent)
    func timeLabelUpdate(race: RaceModel, event: RaceModel.RaceEvent) 
    func noScheduledRaces()

}

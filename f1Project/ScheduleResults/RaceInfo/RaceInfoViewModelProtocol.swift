//
//  RaceInfoViewModelProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 31.07.2022.
//

import UIKit

protocol RaceInfoViewModelProtocol {
    
    var raceInfoModel: RaceModel { get }
    var raceResults: [DriverRaceResult]? { get }
    
    func resultModelFrom(index: Int) -> DriverRaceResult?
    func numberOfRows() -> Int
    func fetchRaceResult(completion: @escaping (Bool) -> ())
    func isCellNeedToRealod(from indexPath: IndexPath) -> Bool
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func chosenCell(indexPath: IndexPath)
}

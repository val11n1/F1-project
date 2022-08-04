//
//  RaceInfoViewModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 31.07.2022.
//

import UIKit

class RaceInfoViewModel: RaceInfoViewModelProtocol {
    
    var raceInfoModel: RaceModel
    var raceResults: [DriverRaceResult]?
    
    private var reloadedIndexPath: IndexPath?
    
    init(withRaceModel raceModel: RaceModel) {
        self.raceInfoModel = raceModel
    }
    
    func fetchRaceResult(completion: @escaping (Bool) -> ()) {

        guard let round = Int(raceInfoModel.round) else {
            completion(false)
            return
        }
        let date = Date().returnCurrentDate()
        DataFetcherService().fetchDriversRaceResult(from: date, round: round) { raceResultModel in
            
            if let raceResultModel = raceResultModel {
                
                self.raceResults = DriverRaceResult.createRaceResultArray(driverRaceResult: raceResultModel)
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func isCellNeedToRealod(from indexPath: IndexPath) -> Bool {
        
        if let reloadedIndexPath = reloadedIndexPath {
            return reloadedIndexPath == indexPath
        }
        return false
    }
    
    func numberOfRows() -> Int {
        
        if let raceResults = raceResults {
            return raceResults.count
        }
        return 0
    }
    
    func resultModelFrom(index: Int) -> DriverRaceResult? {
        
        guard let raceResults = raceResults else { return nil }
        return raceResults[index]
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        guard let reloadedIndexPath = reloadedIndexPath else { return 90 }
        return indexPath == reloadedIndexPath ? 250: 90
    }
    
    func chosenCell(indexPath: IndexPath) {
        if reloadedIndexPath == nil || reloadedIndexPath != indexPath{
            reloadedIndexPath = indexPath
        }else  {
            reloadedIndexPath = nil
        }
    }
}

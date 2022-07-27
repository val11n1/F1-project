//
//  StandingViewModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 27.07.2022.
//

import Foundation


class StandingViewModel: StandingViewModelProtocol {
    
    private var driversArray = [ModelProtocol]()
    private var teamsArray = [ModelProtocol]()
    
    private init(driversArray: [ModelProtocol], teamsArray: [ModelProtocol]) {
        self.driversArray = driversArray
        self.teamsArray = teamsArray
    }
    
    init() {
        
    }
    
    static func createViewModel(completion: @escaping (StandingViewModelProtocol) -> ()) {
        
         var driversArray: [ModelProtocol]?
         var teamsArray: [ModelProtocol]?

        let queue = DispatchQueue(label: "queue")
        let group = DispatchGroup()
        
        group.enter()
        queue.async {
            
            networkingManager.shared.fetchData(type: .DriverResponce, round: nil) { resultArray in
                
                if let resultArray = resultArray {
                    driversArray = resultArray
                    group.leave()
                }
            }
        }
        
        group.enter()
        queue.async {
            
            networkingManager.shared.fetchData(type: .TeamResponce, round: nil) { resultArray in
                
                if let resultArray = resultArray {
                    teamsArray = resultArray
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            
            if let driversArray = driversArray, let teamsArray = teamsArray {
                    
                let viewModel = StandingViewModel(driversArray: driversArray, teamsArray: teamsArray)
                completion(viewModel)

            }else {

                completion(StandingViewModel())
            }
        }
    }
    
    func numberOfItem(selectedSegmentIndex: Int) -> Int {
        
        switch selectedSegmentIndex {
        case 0: return driversArray.count
        case 1: return teamsArray.count
        default: return 0
        }
    }
    
    func returnModelFrom(selectedSegmentIndex: Int, itemIndex: Int) -> ModelProtocol? {
        
        switch selectedSegmentIndex {
        case 0: return driversArray[itemIndex]
        case 1: return teamsArray[itemIndex]
        default: return nil
        }
    }
}


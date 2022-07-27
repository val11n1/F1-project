//
//  StandingViewModelProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 27.07.2022.
//

import Foundation


protocol StandingViewModelProtocol {
    
    
    static func createViewModel(completion: @escaping (StandingViewModelProtocol) -> ())
    
    func numberOfItem(selectedSegmentIndex: Int) -> Int
    func returnModelFrom(selectedSegmentIndex: Int, itemIndex: Int) -> ModelProtocol?
}

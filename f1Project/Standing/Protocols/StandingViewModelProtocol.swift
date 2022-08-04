//
//  StandingViewModelProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 27.07.2022.
//

import UIKit


protocol StandingViewModelProtocol {
    
    var chosenCellIndexPath: IndexPath? { get set }
    
    static func createViewModel(completion: @escaping (StandingViewModelProtocol?) -> ())
    func numberOfItem(selectedSegmentIndex: Int) -> Int
    func returnModelFrom(selectedSegmentIndex: Int, itemIndex: Int) -> ModelProtocol?
    func choseCellAt(indexPath: IndexPath)
    func minimumLineSpacingForSectionAt(selectedSegmentIndex: Int) -> CGFloat
    func sizeForItemAt(indexPath: IndexPath, selectedSegmentIndex: Int) -> CGSize
    func isCellChosen(indexPath: IndexPath) -> Bool

}

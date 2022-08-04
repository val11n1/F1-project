//
//  ThirdPageViewProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 03.08.2022.
//

import UIKit

protocol ThirdPageViewProtocol {
    
    var RaceInfoCellId: String     { get }
    
    var tableView: UITableView!    { get }
    var noResultsLabel: UILabel!   { get }
    
    func standindRaceNotStartYet()
    func standindRaceHaveResults()
}

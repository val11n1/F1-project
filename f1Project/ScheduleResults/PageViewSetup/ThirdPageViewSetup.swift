//
//  ThirdPageViewSetup.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


class ThirdPageViewSetup {
    
    
    static func standingTableViewSetup(pageView: UIView, contentSizeHeight: CGFloat) -> UITableView {
        
        let RaceInfoCellId = "RaceInfoCellId"
        
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        pageView.addSubview(tableview)
        NSLayoutConstraint.activate([
        
            tableview.topAnchor.constraint(equalTo: pageView.topAnchor),
            tableview.widthAnchor.constraint(equalToConstant: pageView.bounds.width),
            tableview.heightAnchor.constraint(equalToConstant: contentSizeHeight)
        ])
        
        tableview.register(RaceInfoCell.self, forCellReuseIdentifier: RaceInfoCellId)
        return tableview
    }
    
    static func standindRaceNotStartYet(pageView: UIView) {
        
        let label = UILabel(text: "There are no results yet", fontSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        pageView.addSubview(label)
        NSLayoutConstraint.activate([
        
            label.centerXAnchor.constraint(equalTo: pageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: pageView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: pageView.bounds.width),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

//
//  ThirdPageViewSetup.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


class ThirdPageView: UIView, ThirdPageViewProtocol {
    
    var RaceInfoCellId = "RaceInfoCellId"
    
    var tableView: UITableView!
    var noResultsLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupConstrains()
        self.activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews()  {
        
        self.backgroundColor = .black
        
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isHidden = true
        tableview.register(RaceInfoCell.self, forCellReuseIdentifier: RaceInfoCellId)
        
        let label = UILabel(text: "There are no results yet", fontSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        self.tableView = tableview
        self.noResultsLabel = label
        self.activityIndicator = activityIndicator
        
        self.addSubview(self.tableView)
        self.addSubview(self.noResultsLabel)
        self.addSubview(self.activityIndicator)

    }
    
    func setupConstrains() {
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.widthAnchor.constraint(equalToConstant: self.bounds.width),
            tableView.heightAnchor.constraint(equalToConstant: self.bounds.height)
        ])
        
        NSLayoutConstraint.activate([
        
            noResultsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            noResultsLabel.widthAnchor.constraint(equalToConstant: self.bounds.width),
            noResultsLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func standindRaceNotStartYet() {
        noResultsLabel.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func standindRaceHaveResults() {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
    }
}

//
//  ScheduleView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 28.07.2022.
//

import Foundation
import UIKit


class ScheduleView: UIView, ScheduleViewProtocol {
    
    var raceCellId = "raceCellId"
    var raceHeaderFooterId = "raceHeaderFooterId"
    
    var activityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var timeLabel: UILabel = {
        return UILabel(text: nil, fontSize: 18)
    }()
    
    var nextEventDescription: UILabel = {
        return UILabel(text: nil, fontSize: 12)
    }()
    
    var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    init(frame: CGRect, viewController: UIViewController) {
        super.init(frame: frame)
        self.setupViews(viewController: viewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(viewController: UIViewController) {
        
        self.addSubview(timeLabel)
        self.addSubview(nextEventDescription)
        self.addSubview(tableView)
        self.addSubview(activityIndicator)
        
        self.tableView.delegate = viewController as? UITableViewDelegate
        self.tableView.dataSource = viewController as? UITableViewDataSource
        tableView.register(RaceCell.self, forCellReuseIdentifier: raceCellId)
        tableView.register(BaseHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: raceHeaderFooterId)
        
        activityIndicator.startAnimating()
    }
    
    func setupConstrains(tabBarHeight: CGFloat?) {
        
        var height = 0.0
        
        if let tabBarHeight = tabBarHeight {
            height = tabBarHeight
        }
        
        NSLayoutConstraint.activate([

            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.safeAreaInsets.top),
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: self.frame.width),
            timeLabel.heightAnchor.constraint(equalToConstant: 40),

            nextEventDescription.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            nextEventDescription.widthAnchor.constraint(equalTo: self.widthAnchor),
            nextEventDescription.heightAnchor.constraint(equalToConstant: 10),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.safeAreaInsets.top + 60),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -height)
        ])
    }
    
    func nextEventDescritionFrom(race: RaceModel, event: RaceModel.RaceEvent) {
        
        if race.thirdPractice != nil {
            
            switch event {
            case .firstPractice:
                nextEventDescription.text = "Time until the first practice start"
            case .secondPractice:
                nextEventDescription.text = "Time until the second practice start"
            case .thirdPracticeOrSprint:
                nextEventDescription.text = "Time until the third practice start"
            case .qualifying:
                nextEventDescription.text = "Time until the qualifying start"
            case .race:
                nextEventDescription.text = "Time until the race start"
            }
            
        }else {
            
            switch event {
            case .firstPractice:
                nextEventDescription.text = "Time until the first practice start"
            case .qualifying:
                nextEventDescription.text = "Time until the qualifying start"
            case .secondPractice:
                nextEventDescription.text = "Time until the second practice start"
            case .thirdPracticeOrSprint:
                nextEventDescription.text = "Time until the sprint start"
            case .race:
                nextEventDescription.text = "Time until the race start"
            }
        }
    }
    
    func timeLabelUpdate(race: RaceModel, event: RaceModel.RaceEvent) {
        
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let date: Date!
        
            switch event {
            case .firstPractice:
                date = race.dateFromEvent(event: .firstPractice)
            case .secondPractice:
                date = race.dateFromEvent(event: .secondPractice)
            case .qualifying:
                date = race.dateFromEvent(event: .qualifying)
            case .race:
                date = race.dateFromEvent(event: .race)
            case .thirdPracticeOrSprint:
                date = race.dateFromEvent(event: .thirdPracticeOrSprint)

            }
        let dateNow = Date().returnCurrentDate()
        
        let dateCountDownComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: dateNow, to: date)
        
        let dateCountDown = calendar.date(from: dateCountDownComponents)
        
        dateFormatter.dateFormat = "d"
        timeLabel.text = "\(dateCountDownComponents.day!) days"
        
        dateFormatter.dateFormat = "HH:mm:ss"
        timeLabel.text = timeLabel.text! + "      " + "\(dateFormatter.string(from: dateCountDown!))"
    }
}

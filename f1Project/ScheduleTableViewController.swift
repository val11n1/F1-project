//
//  ScheduleTableViewController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 01.04.2022.
//

import Foundation
import UIKit


class ScheduleTableViewController: UIViewController {
    
    var raceCellId = "raceCellId"
    var raceHeaderFooterId = "raceHeaderFooterId"
    var isCurrentRaceOnDisplay = false
    var nextRaceCellIndexPath: IndexPath?
    var tableView: UITableView!
    var timeLabel: UILabel!
    var nextEventDescription: UILabel!
    var timer: Timer!
    var upcomingRaceArray: [RaceModel]?
    var pastRacesArray: [RaceModel]? {
        
        didSet {
            
            DispatchQueue.main.sync {
                activityIndicator.stopAnimating()
                tableView.reloadData()
               
            }
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
       fetchScheduleData()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        NSLayoutConstraint.activate([

            timeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: view.safeAreaInsets.top),
            timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            timeLabel.heightAnchor.constraint(equalToConstant: 40),

            nextEventDescription.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            nextEventDescription.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            nextEventDescription.heightAnchor.constraint(equalToConstant: 10),
        ])
      }
    
    
    //MARK: Fetch schedule data
    
    private func fetchScheduleData() {
        
        let queue = DispatchQueue(label: "queueForSchedule", qos: .utility)
        
        queue.async {
            
            networkingManager.shared.fetchSchedule { [unowned self] array in
                if let fetchedArray = array {
                    
                    var pastArray = [RaceModel]()
                    var upcomingArray = [RaceModel]()
                    
                    let date = Date().returnCurrentDate()
                    
                    for race in fetchedArray {
                        
                        if race.raceDateWithOffset() < date {
                            
                            pastArray.append(race)
                        }else {
                            
                            upcomingArray.append(race)
                        }
                        
                    }
                    self.upcomingRaceArray = upcomingArray
                    self.pastRacesArray = pastArray
                    
                    if upcomingRaceArray!.count != 0 {
                        
                        DispatchQueue.main.async { [unowned self] in
                            countDownDescriptionForNextEvent()
                            
                            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownUpdate), userInfo: nil, repeats: true)

                        }
                    }
                    
                }
            }
        }
        
    }
    
    //MARK: Timer update
    
    @objc private func countDownUpdate() {
        
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let race = upcomingRaceArray![0]
        let event = nextUpcomingEvent()
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
    
   
    //MARK: Setup views
    
    private func setupView() {
        
        title = "Races"
        
        timeLabel = UILabel(text: nil, fontSize: 18)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nextEventDescription = UILabel(text: nil, fontSize: 12)
        nextEventDescription.translatesAutoresizingMaskIntoConstraints = false
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(timeLabel)
        self.view.addSubview(nextEventDescription)
        self.view.addSubview(tableView!)
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
        
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navigationController!.navigationBar.frame.maxY + 100),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        tableView.register(RaceCell.self, forCellReuseIdentifier: raceCellId)
        tableView.register(BaseHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: raceHeaderFooterId)
        
        
        activityIndicator.startAnimating()
    }
    
    private func countDownDescriptionForNextEvent() {
        let race = upcomingRaceArray![0]
        let event = nextUpcomingEvent()
        
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
    
    private func nextUpcomingEvent() -> RaceModel.RaceEvent {
        
        let race = upcomingRaceArray![0]
        let dateNow = Date().returnCurrentDate()
        
        var event: RaceModel.RaceEvent!
        
        if race.thirdPractice != nil {
        
        switch true {
        case _ where race.dateFromEvent(event: .firstPractice) > dateNow:
            event = .firstPractice
        case _ where race.dateFromEvent(event: .secondPractice) > dateNow:
            event = .secondPractice
        case _ where race.dateFromEvent(event: .thirdPracticeOrSprint) > dateNow:
            event = .thirdPracticeOrSprint
        case _ where race.dateFromEvent(event: .qualifying) > dateNow:
            event = .qualifying
        case _ where race.dateFromEvent(event: .race) > dateNow:
            event = .race
        default: break
        }

    }else {
        
        switch true {
        case _ where race.dateFromEvent(event: .firstPractice) > dateNow:
            event = .firstPractice
        case _ where race.dateFromEvent(event: .qualifying) > dateNow:
            event = .qualifying
        case _ where race.dateFromEvent(event: .secondPractice) > dateNow:
            event = .secondPractice
        case _ where race.dateFromEvent(event: .thirdPracticeOrSprint) > dateNow:
            event = .thirdPracticeOrSprint
        case _ where race.dateFromEvent(event: .race) > dateNow:
            event = .race
        default: break
        }
    }
      
        return event
    }
}

extension ScheduleTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return upcomingRaceArray == nil ? 0: upcomingRaceArray!.count

        }else {
            
            return pastRacesArray == nil ? 0: pastRacesArray!.count
        }
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: raceCellId) as! RaceCell
        
        let race = indexPath.section == 0 ? upcomingRaceArray![indexPath.row]: pastRacesArray![indexPath.row]
        
       let isNextRaceIndexPath = cell.configure(raceModel: race, isCurrentRace: &isCurrentRaceOnDisplay)
        
        if nextRaceCellIndexPath == nil && isNextRaceIndexPath == true {
            
            nextRaceCellIndexPath = indexPath
        }
        
        if nextRaceCellIndexPath == indexPath {
            
            cell.completionImageView.image = UIImage(named: "next")!
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Upcoming races": "Past races"
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: raceHeaderFooterId) as! BaseHeaderFooterView
        
        return view
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
         self.navigationController?.view.isUserInteractionEnabled = false
         self.tabBarController?.view.isUserInteractionEnabled = false
        let vc = RaceInfoController()
        let raceModel = indexPath.section == 0 ? upcomingRaceArray![indexPath.row]: pastRacesArray![indexPath.row]
        vc.raceInfoModel = raceModel
        navigationController?.pushViewController(vc, animated: false)
        
    }
}

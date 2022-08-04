//
//  ScheduleTableViewController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 01.04.2022.
//

import Foundation
import UIKit


class ScheduleTableViewController: UIViewController {
    
    var timer: Timer!
    var scheduleView: ScheduleViewProtocol!
    var viewModel: ScheduleViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Races"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if scheduleView == nil {
            self.scheduleView = ScheduleView.init(frame: self.view.safeAreaLayoutGuide.layoutFrame, viewController: self)
            self.view.addSubview(self.scheduleView as! UIView)
            createViewModel()
            scheduleView.activityIndicator.startAnimating()
        }

      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func createViewModel() {
        
        ScheduleViewModel.createViewModel { [weak self] viewModel in
            
            self?.scheduleView.activityIndicator.stopAnimating()

            if let viewModel = viewModel {
                
                self?.viewModel = viewModel
                self?.scheduleView.tableView.reloadData()
                
                if viewModel.viewModelHaveUpcomingRacesData() {
                    self?.createTimer()
                }
            }
        }
    }
    
    //MARK: Timer Configure
    
    private func createTimer() {
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDownUpdate), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)

        self.timer = timer
    }
    
    var count = 0
    
    @objc private func countDownUpdate() {
        
        
        if let viewModel = viewModel {
            
            if let race = viewModel.nextUpcomingRace() {
                
                let event = race.nextUpcomingEvent()
                
                switch true {
                case _ where event == .raceHasPassed:
                    self.timer.invalidate()
                    viewModel.nextUpcomingRaceToPastRaces()
                    scheduleView.tableView.reloadData()
                    self.createTimer()
                default:
                    self.scheduleView.timeLabelUpdate(race: race, event: event)
                    self.scheduleView.nextEventDescritionFrom(race: race, event: event)
                }
            }else {
                
                scheduleView.noScheduledRaces()
            }
        }
    }
}

extension ScheduleTableViewController: UITableViewDelegate {
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return viewModel?.heightForRowAt() ?? 44.0
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.scheduleView.raceHeaderFooterId) as! BaseHeaderFooterView
        
        return view
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
         guard let raceModel = viewModel?.raceModelFrom(indexPath: indexPath) else { return }
         //self.navigationController?.view.isUserInteractionEnabled = false
         //self.tabBarController?.view.isUserInteractionEnabled = false
        let vc = RaceInfoController()
        vc.viewModel = RaceInfoViewModel(withRaceModel: raceModel)
        navigationController?.pushViewController(vc, animated: false)
        
    }
}

extension ScheduleTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section: section) ?? 0
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.scheduleView.raceCellId) as! RaceCell
        
        guard let race = viewModel?.raceModelFrom(indexPath: indexPath) else { return cell }
        
        let raceType = viewModel!.typeOf(race: race)
        cell.configure(raceModel: race,raceType: raceType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeaderInSection(section: section)
   }
}

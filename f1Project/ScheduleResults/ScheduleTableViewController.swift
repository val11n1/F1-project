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
        self.scheduleView = ScheduleView(frame: self.view.frame, viewController: self)
        self.view.addSubview(self.scheduleView as! UIView)
        createViewModel()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scheduleView.setupConstrains(tabBarHeight: self.tabBarController?.tabBar.bounds.height)
      }
    
    
    private func createViewModel() {
        
        ScheduleViewModel.createViewModel { [weak self] viewModel in
            
            DispatchQueue.main.async {
                self?.viewModel = viewModel
                self?.scheduleView.activityIndicator.stopAnimating()
                self?.scheduleView.tableView.reloadData()
                
                if viewModel.viewModelHaveUpcomingRacesData() {

                    DispatchQueue.main.async { [unowned self] in
                        self?.DescriptionForNextEvent()

                        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self!, selector: #selector(self?.countDownUpdate), userInfo: nil, repeats: true)
                        timer.tolerance = 0.1
                        RunLoop.current.add(timer, forMode: .common)

                        self?.timer = timer
                    }
                }
            }
        }
    }
    
    //MARK: Timer update
    
    @objc private func countDownUpdate() {
        
        guard let race = viewModel?.nextUpcomingRace() else { return }
        let event = race.nextUpcomingEvent()
        
        self.scheduleView.timeLabelUpdate(race: race, event: event)
        self.DescriptionForNextEvent()
    }
    

    private func DescriptionForNextEvent() {
        
        guard let race = viewModel?.nextUpcomingRace() else { return }
        let event = race.nextUpcomingEvent()
        
        self.scheduleView.nextEventDescritionFrom(race: race, event: event)
    }
    
}

extension ScheduleTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
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
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return viewModel?.heightForRowAt() ?? 44.0
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return viewModel?.numberOfSections() ?? 0
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return viewModel?.titleForHeaderInSection(section: section) 
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.scheduleView.raceHeaderFooterId) as! BaseHeaderFooterView
        
        return view
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
         guard let raceModel = viewModel?.raceModelFrom(indexPath: indexPath) else { return }
         self.navigationController?.view.isUserInteractionEnabled = false
         self.tabBarController?.view.isUserInteractionEnabled = false
        let vc = RaceInfoController()
        vc.raceInfoModel = raceModel
        navigationController?.pushViewController(vc, animated: false)
        
    }
}

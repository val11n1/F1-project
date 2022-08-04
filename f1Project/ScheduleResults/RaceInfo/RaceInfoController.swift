//
//  ScrollViewTraining.swift
//  f1Project
//
//  Created by Valeriy Trusov on 06.04.2022.
//

import Foundation
import UIKit


class RaceInfoController: UIViewController {
    
    var raceInfoModel: RaceModel!
    var viewModel: RaceInfoViewModelProtocol!

    var tableview: UITableView!
    var scrollView: RaceInfoScrollView!

    var segmentImage: UIImageView!
    
    var activityIndicatorOnFirstPage: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {

        title = viewModel.raceInfoModel.name
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if scrollView == nil {
            
            createViews()
            setSegmentImage()
            
            viewModel.fetchRaceResult { [weak self] isDataNotEmpty in
                
                if isDataNotEmpty == false || self?.viewModel.raceResults!.count == 0 {
                    
                    self?.scrollView.secondPage.shortDescriptionWithoutRaceResult()
                    self?.scrollView.thirdPage.standindRaceNotStartYet()
                    
                }else {
                    
                    let firstThreeDrivers: [DriverRaceResult] = Array(self?.viewModel.raceResults![0...2] ?? [])
                    self?.scrollView.secondPage.shortDescriptionFrom(raceResult: firstThreeDrivers)
                    self?.scrollView.thirdPage.tableView.delegate = self
                    self?.scrollView.thirdPage.tableView.dataSource = self
                    self?.scrollView.thirdPage.standindRaceHaveResults()
                    self?.scrollView.thirdPage.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: Setup views
    
    private func createViews() {
        
        let frame = CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.origin.x,
                           y: self.view.safeAreaLayoutGuide.layoutFrame.origin.y + 30,
                           width: self.view.bounds.width,
                           height: self.view.safeAreaLayoutGuide.layoutFrame.size.height - 40)
        self.scrollView = RaceInfoScrollView(frame: frame, raceInfoModel: viewModel.raceInfoModel)
        self.scrollView.delegate = self
        self.view.addSubview(scrollView)
    }
    
    private func setSegmentImage() {
        
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "firstPage")
        
        view.addSubview(iv)
        
        NSLayoutConstraint.activate([
        
            iv.topAnchor.constraint(equalTo: view.topAnchor, constant: self.view.safeAreaInsets.top),
            iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iv.widthAnchor.constraint(equalToConstant: 50),
            iv.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        segmentImage = iv
        
    }
}

extension RaceInfoController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  scrollView.superview != self.scrollView.thirdPage.tableView.superview {
            
            switch scrollView.contentOffset.x {
            case 0:
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [unowned self] in
                    
                    segmentImage.image = UIImage(named: "firstPage")
                    title = viewModel.raceInfoModel.name
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                }
            case view.bounds.size.width:
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [unowned self] in
                    
                    segmentImage.image = UIImage(named: "secondPage")
                    title = "Race info"
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                }
            case view.bounds.size.width * 2:
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [unowned self] in
                    
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    segmentImage.image = UIImage(named: "thirdPage")
                    title = "Results"
                }
            default: break
            }
        }
    }
}


extension RaceInfoController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.scrollView.thirdPage.RaceInfoCellId) as! RaceInfoCell
        
        guard let resultModel = viewModel.resultModelFrom(index: indexPath.row) else { return cell }
        let isChosen = viewModel.isCellNeedToRealod(from: indexPath)
        cell.configure(raceResultModel: resultModel, isChosenCell: isChosen)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.chosenCell(indexPath: indexPath)
        scrollView.thirdPage.tableView.reloadData()
//        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut) { [weak self] in
//            self?.scrollView.thirdPage.tableView.beginUpdates()
//            self?.scrollView.thirdPage.tableView.reloadRows(at: [indexPath], with: .automatic)
//            self?.scrollView.thirdPage.tableView.endUpdates()
//        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear){ [ weak self] in
            
            self?.scrollView.thirdPage.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}

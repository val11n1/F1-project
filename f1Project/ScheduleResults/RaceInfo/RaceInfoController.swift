//
//  ScrollViewTraining.swift
//  f1Project
//
//  Created by Valeriy Trusov on 06.04.2022.
//

import Foundation
import UIKit


class RaceInfoController: UIViewController, UIScrollViewDelegate {
    
    let RaceInfoCellId = "RaceInfoCellId"
    
    var reloadedIndexPath: IndexPath?
    let heightForSegmentImage: CGFloat = 30
    
    var firstPageView: UIView!
    var secondPageView: UIView!
    var thirdPageView: UIView!
    var scrollView: UIScrollView!
    
    var raceInfoModel: RaceModel!
    
    var firstPlaceDriverLabel: UILabel!
    var firstPlaceTeamLabel: UILabel!
    
    var secondPlaceDriverLabel: UILabel!
    var secondPlaceTeamLabel: UILabel!
    
    var thirdPlaceDriverLabel: UILabel!
    var thirdPlaceTeamLabel: UILabel!
    
    var tableview: UITableView!
    
    var raceResults: [RaceResult]?
   
    var segmentImage: UIImageView!
    
    var activityIndicatorOnFirstPage: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        
        createViews()
        fetchRaceResults()
        title = raceInfoModel.name
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
    //MARK: Fetch Race results
    
    private func fetchRaceResults() {
        
        let queue = DispatchQueue(label: "queueForRaceResults", qos: .userInitiated, attributes: .concurrent)
        
        queue.async {
            
            networkingManager.shared.fetchData(type: .RaceResultResponce, round: Int(self.raceInfoModel.round)) {[unowned self] array in
                
                if let racesArray = array as? [RaceResult] {
                    
                    DispatchQueue.main.sync {
                        
                        firstPlaceDriverLabel.text = racesArray[0].driverFirstName + " " + racesArray[0].driverLastName
                        firstPlaceTeamLabel.text = racesArray[0].constructorName
                        
                        secondPlaceDriverLabel.text = racesArray[1].driverFirstName + " " + racesArray[1].driverLastName
                        secondPlaceTeamLabel.text = racesArray[1].constructorName
                        
                        thirdPlaceDriverLabel.text = racesArray[2].driverFirstName + " " + racesArray[2].driverLastName
                        thirdPlaceTeamLabel.text = racesArray[2].constructorName
                        raceResults = racesArray
                        
                        let tableview = ThirdPageViewSetup.standingTableViewSetup(pageView: thirdPageView, contentSizeHeight: scrollView.contentSize.height)
                        tableview.delegate = self
                        tableview.dataSource = self
                        self.tableview = tableview
                        
                        setSegmentImage()

                        self.navigationController?.view.isUserInteractionEnabled = true
                        self.tabBarController?.view.isUserInteractionEnabled = true
                        activityIndicatorOnFirstPage.stopAnimating()
                    }
                    
                }else {
                    
                    DispatchQueue.main.sync {
                        
                        firstPlaceDriverLabel.text = "There are no results yet"
                        ThirdPageViewSetup.standindRaceNotStartYet(pageView: thirdPageView)
                        setSegmentImage()

                        self.navigationController?.view.isUserInteractionEnabled = true
                        self.tabBarController?.view.isUserInteractionEnabled = true
                        activityIndicatorOnFirstPage.stopAnimating()

                    }
                }
            }
        }
    }
    
    //MARK: Setup views
    
    private func createViews() {
        
        var frame = CGRect(x: view.bounds.origin.x, y: navigationController!.navigationBar.frame.maxY + heightForSegmentImage, width: view.bounds.width, height: (view.bounds.height - navigationController!.navigationBar.frame.maxY) - navigationController!.tabBarController!.tabBar.bounds.size.height)
        
        scrollView = UIScrollView(frame: frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: frame.size.width * 3, height: view.bounds.height - navigationController!.navigationBar.frame.maxY - navigationController!.tabBarController!.tabBar.bounds.height - heightForSegmentImage)
        
        frame.origin.y = 0
        
        firstPageView = UIView.initWith(frame: frame)
        
        frame.origin.x += frame.size.width
        secondPageView = UIView.initWith(frame: frame)
        
        frame.origin.x += frame.size.width
        thirdPageView = UIView.initWith(frame: frame)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(firstPageView)
        scrollView.addSubview(secondPageView)
        scrollView.addSubview(thirdPageView)
        
        firstPageActivityIndicatorSetup()
        FirstPageViewSetup.setupPageView(pageView: firstPageView, raceInfoModel: raceInfoModel, contentSizeHeight: scrollView.contentSize.height)
        SecondPageViewSetup.setupPageView(pageView: secondPageView, raceInfoModel: raceInfoModel, contentSizeHeight: scrollView.contentSize.height)
        firstThreeRacers()
    }
    
    //MARK: firstPageView Configure
    
    private func firstPageActivityIndicatorSetup() {
        
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        
        view.addSubview(ai)
        
        NSLayoutConstraint.activate([
        
            ai.bottomAnchor.constraint(equalTo: view.topAnchor, constant: navigationController!.navigationBar.frame.maxY + 20),
            ai.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ai.widthAnchor.constraint(equalToConstant: 50),
            ai.heightAnchor.constraint(equalToConstant: heightForSegmentImage)
        ])
        ai.startAnimating()
        activityIndicatorOnFirstPage = ai
    }
    
    private func setSegmentImage() {
        
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "firstPage")
        
        view.addSubview(iv)
        
        NSLayoutConstraint.activate([
        
            iv.bottomAnchor.constraint(equalTo: view.topAnchor, constant: navigationController!.navigationBar.frame.maxY + 20),
            iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iv.widthAnchor.constraint(equalToConstant: 50),
            iv.heightAnchor.constraint(equalToConstant: heightForSegmentImage)
        ])
        
        segmentImage = iv
        
    }
    
    //MARK: Second page configure
    
    private func firstThreeRacers() {
        
       let firstThreeDriversLabels = SecondPageViewSetup.firstThreeDriversSetup(pageView: secondPageView, contentSizeHeight: scrollView.contentSize.height)
        
        firstPlaceDriverLabel  = firstThreeDriversLabels.firstPlaceDriverLabel
        firstPlaceTeamLabel    = firstThreeDriversLabels.firstPlaceTeamLabel
        
        secondPlaceDriverLabel = firstThreeDriversLabels.secondPlaceDriverLabel
        secondPlaceTeamLabel   = firstThreeDriversLabels.secondPlaceTeamLabel
        
        thirdPlaceDriverLabel  = firstThreeDriversLabels.thirdPlaceDriverLabel
        thirdPlaceTeamLabel    = firstThreeDriversLabels.thirdPlaceTeamLabel
    }
    

    
    //MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.tableview != nil && scrollView.superview != self.tableview.superview || self.tableview == nil {
            
        switch scrollView.contentOffset.x {
            
        case 0:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [unowned self] in
                
                segmentImage.image = UIImage(named: "firstPage")
                title = raceInfoModel.name
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
        
        return raceResults!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RaceInfoCellId) as! RaceInfoCell
        
        let resultModel = raceResults![indexPath.row]
        cell.configure(raceResultModel: resultModel)
        cell.statStackViewHeightConstraint.constant = reloadedIndexPath == indexPath ? 150: 0
        cell.showStatImageView.image = reloadedIndexPath == indexPath ? UIImage(named: "up"): UIImage(named: "down")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath == reloadedIndexPath ? 250: 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if reloadedIndexPath == nil || reloadedIndexPath != indexPath{
            
            reloadedIndexPath = indexPath
            
        }else  {
            
            reloadedIndexPath = nil
            
        }
        
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear){
            
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}

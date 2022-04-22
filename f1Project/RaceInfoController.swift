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
    
    var currentTask: URLSessionDataTask!
    
    var reloadedIndexPath: IndexPath?
    let heightForSegmentImage: CGFloat = 30
    
    var firstPageView: UIView!
    var secondPageView: UIView!
    var thirdPageView: UIView!
    
    var scrollView: UIScrollView!
    var raceInfoModel: RaceModel!
    var raceDistanceStackView: UIStackView!
    
    var firstPlaceDriverLabel: UILabel!
    var firstPlaceTeamLabel: UILabel!
    
    var secondPlaceDriverLabel: UILabel!
    var secondPlaceTeamLabel: UILabel!
    
    var thirdPlaceDriverLabel: UILabel!
    var thirdPlaceTeamLabel: UILabel!
    
    var tableview: UITableView!
    
    var raceResults: [RaceResult]?
   
    var segmentImage: UIImageView!
    
    let activityIndicatorForWinners: UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        return ai
    }()
    
    let activityIndicatorOnFirstPage: UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        return ai
    }()
    
    let activityIndicatorForStanding: UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        return ai
    }()
    
    let raceInfoDict: [String: (image: UIImage, laps: Int,lapDistance: Int, distance: Float)] =
    ["Bahrain Grand Prix": (UIImage(named: "bahrain")!, 57, 5412, 308.238),
     "Saudi Arabian Grand Prix": (UIImage(named: "jeddah")!, 50, 6174, 308.450),
     "Australian Grand Prix": (UIImage(named: "australian")!, 58, 5303, 307.574),
     "Emilia Romagna Grand Prix": (UIImage(named: "imola")!, 63, 4909, 309.049),
     "Miami Grand Prix": (UIImage(named: "miami")!, 57, 5410, 308.370),
     "Spanish Grand Prix": (UIImage(named: "spain")!, 66, 4655, 307.104),
     "Monaco Grand Prix": (UIImage(named: "monaco")!, 78, 3337, 260.286),
     "Azerbaijan Grand Prix": (UIImage(named: "az")!, 51, 6003, 306.049),
     "Canadian Grand Prix": (UIImage(named: "canada")!, 70, 4361, 305.270),
     "British Grand Prix": (UIImage(named: "uk")!, 52, 5891, 306.198),
     "Austrian Grand Prix": (UIImage(named: "austria")!, 71, 4318, 306.452),
     "French Grand Prix": (UIImage(named: "france")!, 53, 5842, 309.626),
     "Hungarian Grand Prix": (UIImage(named: "hungaroring")!, 70, 4381, 306.663),
     "Belgian Grand Prix": (UIImage(named: "spa")!, 44, 7004, 308.176),
     "Dutch Grand Prix": (UIImage(named: "nederland")!, 70, 4180, 292.600),
     "Italian Grand Prix": (UIImage(named: "italian")!, 53, 5793, 306.720),
     "Singapore Grand Prix": (UIImage(named: "singapore")!, 61, 5065, 308.828),
     "Japanese Grand Prix": (UIImage(named: "japanese")!, 53, 5807, 307.471),
     "United States Grand Prix": (UIImage(named: "usaAustin")!, 56, 5513, 308.405),
     "Mexico City Grand Prix": (UIImage(named: "mexico")!, 71, 4304, 305.354),
     "Brazilian Grand Prix": (UIImage(named: "brazil")!, 71, 4309, 305.909),
     "Abu Dhabi Grand Prix": (UIImage(named: "abudabi")!, 58, 5281, 306.183)]
    
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
                        activityIndicatorForWinners.stopAnimating()
                        raceResults = racesArray
                        standingTableViewSetup()
                        setSegmentImage()

                        self.navigationController?.view.isUserInteractionEnabled = true
                        self.tabBarController?.view.isUserInteractionEnabled = true
                        activityIndicatorOnFirstPage.stopAnimating()
                    }
                    
                }else {
                    
                    DispatchQueue.main.sync {
                        
                        firstPlaceDriverLabel.text = "There are no results yet"
                        activityIndicatorForWinners.stopAnimating()
                        standindRaceNotStartYet()
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
        
        firstPageView = UIView(frame: frame)
        firstPageView.backgroundColor = .black
        
        frame.origin.x += frame.size.width
        secondPageView = UIView(frame: frame)
        secondPageView.backgroundColor = .black
        
        frame.origin.x += frame.size.width
        thirdPageView = UIView(frame: frame)
        thirdPageView.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(firstPageView)
        scrollView.addSubview(secondPageView)
        scrollView.addSubview(thirdPageView)
        
        firstPageViewSetup()
        secondPageViewSetup()
        thirdPageViewSetup()
    }
    
    //MARK: Third page configure
    
    private func thirdPageViewSetup() {
        
        thirdPageView.addSubview(activityIndicatorForStanding)
        NSLayoutConstraint.activate([
        
            activityIndicatorForStanding.centerXAnchor.constraint(equalTo: thirdPageView.centerXAnchor),
            activityIndicatorForStanding.centerYAnchor.constraint(equalTo: thirdPageView.centerYAnchor),
            activityIndicatorForStanding.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorForStanding.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        activityIndicatorForStanding.startAnimating()
    }
    
    private func standingTableViewSetup() {
        
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        thirdPageView.addSubview(tableview)
        NSLayoutConstraint.activate([
        
            tableview.topAnchor.constraint(equalTo: thirdPageView.topAnchor),
            tableview.widthAnchor.constraint(equalToConstant: view.bounds.width),
            tableview.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height)
        ])
        
        
        tableview.register(RaceInfoCell.self, forCellReuseIdentifier: RaceInfoCellId)
        self.tableview = tableview
        activityIndicatorForStanding.stopAnimating()
    }
    
    private func standindRaceNotStartYet() {
        
        activityIndicatorForStanding.stopAnimating()
        let label = UILabel(text: "There are no results yet", fontSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        thirdPageView.addSubview(label)
        NSLayoutConstraint.activate([
        
            label.centerXAnchor.constraint(equalTo: thirdPageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: thirdPageView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: view.bounds.width),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: Second page configure
    
    private func secondPageViewSetup() {
        
        let raceInfo = raceInfoDict[raceInfoModel.name]!
        
        let placeLabels = labelsForPage(firstLabelText: "Place", secondLabelText: "\(raceInfoModel.locality), \(raceInfoModel.country)")
        let lapsContLabels = labelsForPage(firstLabelText: "Laps", secondLabelText: "\(raceInfo.laps)")
        let oneLapLabels = labelsForPage(firstLabelText: "1 lap distance", secondLabelText: "\(raceInfo.lapDistance)m")
        let raceDistanceLabels = labelsForPage(firstLabelText: "Distance", secondLabelText: "\(raceInfo.distance)km")
        
        let placeSV = UIStackView(arrangedSubviews: placeLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let lapCountSV = UIStackView(arrangedSubviews: lapsContLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let oneLapSV = UIStackView(arrangedSubviews: oneLapLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let raceDistanceSV = UIStackView(arrangedSubviews: raceDistanceLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        raceDistanceStackView = raceDistanceSV
        
        let arraySV = [placeSV, lapCountSV, oneLapSV, raceDistanceSV]
        
        for (index, sv) in arraySV.enumerated() {
            
            secondPageView.addSubview(sv)

            if index == 0 {
                
                NSLayoutConstraint.activate([
                
                    sv.topAnchor.constraint(equalTo: secondPageView.topAnchor),
                    sv.widthAnchor.constraint(equalToConstant: view.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 4)
                ])
                
            }else {
                
                NSLayoutConstraint.activate([
                
                    sv.topAnchor.constraint(equalTo: arraySV[index - 1].bottomAnchor),
                    sv.widthAnchor.constraint(equalToConstant: view.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 4)
                ])
                
            }
        }
        firstThreeDriversSetup()
    }
    
    private func firstThreeDriversSetup() {
        
        let firstPlaceImageView = UIImageView()
        firstPlaceImageView.translatesAutoresizingMaskIntoConstraints = false
        firstPlaceImageView.contentMode = .scaleAspectFit
        firstPlaceImageView.image = UIImage(named: "medal1")
        
        let secondPlaceImageView = UIImageView()
        secondPlaceImageView.translatesAutoresizingMaskIntoConstraints = false
        secondPlaceImageView.contentMode = .scaleAspectFit
        secondPlaceImageView.image = UIImage(named: "medal2")
        
        let thirdPlaceImageView = UIImageView()
        thirdPlaceImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdPlaceImageView.contentMode = .scaleAspectFit
        thirdPlaceImageView.image = UIImage(named: "medal3")
        
        firstPlaceDriverLabel = UILabel(text: nil, fontSize: 15)
        firstPlaceTeamLabel = UILabel(text: nil, fontSize: 15)
        
        secondPlaceDriverLabel = UILabel(text: nil, fontSize: 15)
        secondPlaceTeamLabel = UILabel(text: nil, fontSize: 15)
        
        thirdPlaceDriverLabel = UILabel(text: nil, fontSize: 15)
        thirdPlaceTeamLabel = UILabel(text: nil, fontSize: 15)
    
        let firstPlaceSV = UIStackView(arrangedSubviews: [firstPlaceDriverLabel, firstPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        let secondPlaceSV = UIStackView(arrangedSubviews: [secondPlaceDriverLabel, secondPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        let thirdPlaceSV = UIStackView(arrangedSubviews: [thirdPlaceDriverLabel, thirdPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        secondPageView.addSubview(firstPlaceImageView)
        secondPageView.addSubview(firstPlaceSV)
        secondPageView.addSubview(secondPlaceImageView)
        secondPageView.addSubview(secondPlaceSV)
        secondPlaceDriverLabel.addSubview(activityIndicatorForWinners)
        secondPageView.addSubview(thirdPlaceSV)
        secondPageView.addSubview(thirdPlaceImageView)
        NSLayoutConstraint.activate([
        
            firstPlaceImageView.topAnchor.constraint(equalTo: raceDistanceStackView.bottomAnchor),
            firstPlaceImageView.leadingAnchor.constraint(equalTo: secondPageView.leadingAnchor, constant: 2),
            firstPlaceImageView.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 3),
            firstPlaceImageView.widthAnchor.constraint(equalToConstant: (view.bounds.width / 4) - 2),
            
            firstPlaceSV.topAnchor.constraint(equalTo: raceDistanceStackView.bottomAnchor),
            firstPlaceSV.leadingAnchor.constraint(equalTo: firstPlaceImageView.trailingAnchor, constant: 5),
            firstPlaceSV.widthAnchor.constraint(equalToConstant: view.bounds.width - view.bounds.width / 3),
            firstPlaceSV.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 3),
            
            secondPlaceImageView.topAnchor.constraint(equalTo: firstPlaceImageView.bottomAnchor),
            secondPlaceImageView.leadingAnchor.constraint(equalTo: secondPageView.leadingAnchor, constant: 2),
            secondPlaceImageView.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 3),
            secondPlaceImageView.widthAnchor.constraint(equalToConstant: (view.bounds.width / 4) - 2),
            
            secondPlaceSV.topAnchor.constraint(equalTo: firstPlaceSV.bottomAnchor),
            secondPlaceSV.leadingAnchor.constraint(equalTo: secondPlaceImageView.trailingAnchor, constant: 5),
            secondPlaceSV.widthAnchor.constraint(equalToConstant: view.bounds.width - view.bounds.width / 3),
            secondPlaceSV.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 3),
            
            activityIndicatorForWinners.centerXAnchor.constraint(equalTo: secondPlaceDriverLabel.centerXAnchor),
            activityIndicatorForWinners.centerYAnchor.constraint(equalTo: secondPlaceDriverLabel.centerYAnchor),
            activityIndicatorForWinners.heightAnchor.constraint(equalToConstant: 50),
            activityIndicatorForWinners.widthAnchor.constraint(equalToConstant: 50),
            
            thirdPlaceImageView.topAnchor.constraint(equalTo: secondPlaceImageView.bottomAnchor),
            thirdPlaceImageView.leadingAnchor.constraint(equalTo: secondPageView.leadingAnchor, constant: 2),
            thirdPlaceImageView.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 3),
            thirdPlaceImageView.widthAnchor.constraint(equalToConstant: (view.bounds.width / 4) - 2),
            
            thirdPlaceSV.topAnchor.constraint(equalTo: secondPlaceSV.bottomAnchor),
            thirdPlaceSV.leadingAnchor.constraint(equalTo: thirdPlaceImageView.trailingAnchor, constant: 5),
            thirdPlaceSV.widthAnchor.constraint(equalToConstant: view.bounds.width - view.bounds.width / 3),
            thirdPlaceSV.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 3)
        ])
        
        activityIndicatorForWinners.startAnimating()
    }
    
    //MARK: First page configure
    
    private func firstPageViewSetup() {
        
        firstPageActivityIndicatorSetup()
        
        let raceImageView = UIImageView()
            
        if let image = raceInfoDict[raceInfoModel.name]?.image {
                
                raceImageView.image = image
            }
        
        raceImageView.backgroundColor = .white
        raceImageView.layer.cornerRadius = 15
        raceImageView.contentMode = .scaleAspectFit
        raceImageView.translatesAutoresizingMaskIntoConstraints = false
        
        firstPageView.addSubview(raceImageView)
        NSLayoutConstraint.activate([
        
            raceImageView.topAnchor.constraint(equalTo: firstPageView.topAnchor),
            raceImageView.widthAnchor.constraint(equalToConstant: firstPageView.frame.size.width),
            raceImageView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height / 2)
        ])
        
        let firstPracticeLabel = UILabel.init(text: "First Practice", fontSize: 15, textAlignment: .left)
        let firstPracticeDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)
        
        let secondPracticeLabel = UILabel.init(text: "Second Practice", fontSize: 15, textAlignment: .left)
        let secondPracticeDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)
        
        let qualifyingLabel = UILabel.init(text: "Qualifying", fontSize: 15, textAlignment: .left)
        let qualifyingDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)
        
        let raceLabel = UILabel.init(text: "Race", fontSize: 15, textAlignment: .left)
        let raceDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)
        
        dateAndTimeForEvent(date: raceInfoModel.firstPractice.date, time: raceInfoModel.firstPractice.time, viewForText: firstPracticeDescriptionLabel)
        dateAndTimeForEvent(date: raceInfoModel.secondPractice.date, time: raceInfoModel.secondPractice.time, viewForText: secondPracticeDescriptionLabel)
        dateAndTimeForEvent(date: raceInfoModel.qualifying.date, time: raceInfoModel.qualifying.time, viewForText: qualifyingDescriptionLabel)
        dateAndTimeForEvent(date: raceInfoModel.date, time: raceInfoModel.time, viewForText: raceDescriptionLabel)
        
        let firstSw = UIStackView(arrangedSubviews: [firstPracticeLabel, firstPracticeDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
        
        let secondSw = UIStackView(arrangedSubviews: [secondPracticeLabel, secondPracticeDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
        let qualifyingSw = UIStackView(arrangedSubviews: [qualifyingLabel, qualifyingDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
        let raceSw = UIStackView(arrangedSubviews: [raceLabel, raceDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)

        var arrayViews = [UIStackView]()
        
        if raceInfoModel.sprint != nil {
            
            let sprintLabel = UILabel.init(text: "Sprint", fontSize: 15, textAlignment: .left)
            let sprintDescriptionLabel = UILabel(text: nil, fontSize: 15, textAlignment: .right)
            let sprintSW = UIStackView(arrangedSubviews: [sprintLabel, sprintDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
            
            dateAndTimeForEvent(date: raceInfoModel.sprint!.date, time: raceInfoModel.sprint!.time, viewForText: sprintDescriptionLabel)
            
            arrayViews = [firstSw, qualifyingSw, secondSw, sprintSW, raceSw]
            
        }else {
            
            let tpLabel = UILabel.init(text: "Third practice", fontSize: 15, textAlignment: .left)
            let tpDescriptionLabel = UILabel(text: nil, fontSize: 15, textAlignment: .right)
            let tpStackView = UIStackView(arrangedSubviews: [tpLabel, tpDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
            
            dateAndTimeForEvent(date: raceInfoModel.thirdPractice!.date, time: raceInfoModel.thirdPractice!.time, viewForText: tpDescriptionLabel)
            
            arrayViews = [firstSw, secondSw, tpStackView, qualifyingSw, raceSw]
        }
        
        
        for (index, sv) in arrayViews.enumerated() {
            
            firstPageView.addSubview(sv)

            if index == 0 {
                
                NSLayoutConstraint.activate([
                
                    sv.topAnchor.constraint(equalTo: raceImageView.bottomAnchor),
                    sv.widthAnchor.constraint(equalToConstant: view.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 5)
                ])
                
            }else {
                
                NSLayoutConstraint.activate([

                sv.topAnchor.constraint(equalTo: arrayViews[index - 1].bottomAnchor),
                sv.widthAnchor.constraint(equalToConstant: view.bounds.width),
                sv.heightAnchor.constraint(equalToConstant: (scrollView.contentSize.height / 2) / 5)
                  ])
            }
        }
        
    }
    
    private func firstPageActivityIndicatorSetup() {
        
        view.addSubview(activityIndicatorOnFirstPage)
        
        NSLayoutConstraint.activate([
        
            activityIndicatorOnFirstPage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: navigationController!.navigationBar.frame.maxY + 20),
            activityIndicatorOnFirstPage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorOnFirstPage.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorOnFirstPage.heightAnchor.constraint(equalToConstant: heightForSegmentImage)
        ])
        activityIndicatorOnFirstPage.startAnimating()
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
    
    //MARK: Supporting methods
    
    private func labelsForPage(firstLabelText: String?, secondLabelText: String) -> [UILabel] {
        
        let firstLabel = UILabel(text: firstLabelText, fontSize: 18, textAlignment: .left)
        let secondLabel = UILabel(text: secondLabelText, fontSize: 18, textAlignment: .right)
        
        return [firstLabel, secondLabel]
    }
    
    
    //MARK: Parsing date
    
    private func dateAndTimeForEvent(date: String, time: String, viewForText: UILabel) {
        
        let dateFormatter = DateFormatter()
        //let calendar = Calendar.current
        
        let timeZoneOfset = TimeInterval(TimeZone.current.secondsFromGMT())
        
        dateFormatter.dateFormat = "HH:mm"
        let eventTime = dateFormatter.date(from: time)!.addingTimeInterval(timeZoneOfset)
        let eventTimeString = dateFormatter.string(from: eventTime)
        
        dateFormatter.dateFormat = "yyyy-MM-dd/"
        let eventDate = dateFormatter.date(from: date)!.addingTimeInterval(timeZoneOfset)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let eventDateString = dateFormatter.string(from: eventDate)

        viewForText.text = "Date: \(eventDateString), time: \(eventTimeString)"
        
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

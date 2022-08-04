//
//  SecondPageViewSetup.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


class SecondPageView: UIView, SecondPageViewProtocol {
    
    var firstPlaceImageView:  UIImageView!
    var secondPlaceImageView: UIImageView!
    var thirdPlaceImageView:  UIImageView!
    
    var firstPlaceDriverLabel:  UILabel!
    var firstPlaceTeamLabel:    UILabel!
    
    var secondPlaceDriverLabel: UILabel!
    var secondPlaceTeamLabel:   UILabel!
    
    var thirdPlaceDriverLabel:  UILabel!
    var thirdPlaceTeamLabel:    UILabel!
    
    private var firstPlaceSV:  UIStackView!
    private var secondPlaceSV: UIStackView!
    private var thirdPlaceSV:  UIStackView!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var arrayTrackDescriptionStackViews: [UIStackView]!
    //private var arrayRaceShortDescriptionsStackViews: [UIStackView]!
    private let numberOfDriversToShow: CGFloat = 3
    
    
    init(frame: CGRect, raceInfoModel: RaceModel) {
        super.init(frame: frame)
        setupRaceDescriptionViews(raceInfoModel: raceInfoModel)
        setupConstrainsForRaceDescriptionViews()
        createViewsForRaceShortDescription()
        setupConstrainsForRaceShortDescriptionViews()
        self.activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SecondPageViewProtocol
    
    func shortDescriptionFrom(raceResult: [DriverRaceResult]) {
        
        self.activityIndicator.stopAnimating()
        
        guard raceResult.count == 3
        else {
            shortDescriptionWithoutRaceResult()
            return
        }
        let firstDriver = raceResult.first!
        let thirdDriver = raceResult.last!
        let secondDriver = raceResult[1]
        
        firstPlaceDriverLabel.text = firstDriver.driverFirstName + " " + firstDriver.driverLastName
        firstPlaceTeamLabel.text = firstDriver.constructorName
        
        secondPlaceDriverLabel.text = secondDriver.driverFirstName + " " + secondDriver.driverLastName
        secondPlaceTeamLabel.text = secondDriver.constructorName
        
        thirdPlaceDriverLabel.text = thirdDriver.driverFirstName + " " + thirdDriver.driverLastName
        thirdPlaceTeamLabel.text = thirdDriver.constructorName
    }
    
    func shortDescriptionWithoutRaceResult() {
        self.activityIndicator.stopAnimating()
        self.secondPlaceDriverLabel.text = "There are no results yet"
    }
    
    //MARK: Creating views methods
    
    private func setupRaceDescriptionViews(raceInfoModel: RaceModel) {
        
        self.backgroundColor = .black
        
        guard let raceInfo = RaceInfoParams.raceInfoDict[raceInfoModel.name] else { return }
        
        let placeLabels = labelsForPage(firstLabelText: "Place", secondLabelText: "\(raceInfoModel.locality), \(raceInfoModel.country)", fontSize: 18)
        let lapsContLabels = labelsForPage(firstLabelText: "Laps", secondLabelText: "\(raceInfo.laps)", fontSize: 18)
        let oneLapLabels = labelsForPage(firstLabelText: "1 lap distance", secondLabelText: "\(raceInfo.lapDistance)m", fontSize: 18)
        let raceDistanceLabels = labelsForPage(firstLabelText: "Distance", secondLabelText: "\(raceInfo.distance)km", fontSize: 18)
        
        let placeSV = UIStackView(arrangedSubviews: placeLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let lapCountSV = UIStackView(arrangedSubviews: lapsContLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let oneLapSV = UIStackView(arrangedSubviews: oneLapLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let raceDistanceSV = UIStackView(arrangedSubviews: raceDistanceLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        
        arrayTrackDescriptionStackViews = [placeSV, lapCountSV, oneLapSV, raceDistanceSV]
        
        for stackView in arrayTrackDescriptionStackViews {
            
            self.addSubview(stackView)
        }
    }
    
    
    private func createViewsForRaceShortDescription() {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator = activityIndicator
        
        firstPlaceImageView = createImageView(imageName: "medal1")
        secondPlaceImageView = createImageView(imageName: "medal2")
        thirdPlaceImageView = createImageView(imageName: "medal3")
        
        firstPlaceDriverLabel = UILabel(fontSize: 15, textAlignment: .left)
        firstPlaceTeamLabel = UILabel(fontSize: 15, textAlignment: .right)
        
        secondPlaceDriverLabel = UILabel(fontSize: 15, textAlignment: .left)
        secondPlaceTeamLabel = UILabel(fontSize: 15, textAlignment: .right)
        
        thirdPlaceDriverLabel = UILabel(fontSize: 15, textAlignment: .left)
        thirdPlaceTeamLabel = UILabel(fontSize: 15, textAlignment: .right)
        
        firstPlaceSV = UIStackView(arrangedSubviews: [firstPlaceDriverLabel, firstPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        secondPlaceSV = UIStackView(arrangedSubviews: [secondPlaceDriverLabel, secondPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        thirdPlaceSV = UIStackView(arrangedSubviews: [thirdPlaceDriverLabel, thirdPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        self.addSubview(firstPlaceImageView)
        self.addSubview(firstPlaceSV)
        self.addSubview(secondPlaceImageView)
        self.addSubview(secondPlaceSV)
        self.addSubview(thirdPlaceSV)
        self.addSubview(thirdPlaceImageView)
        self.addSubview(self.activityIndicator)
    }
    
    //MARK: Setup constraints methods
    
    private func setupConstrainsForRaceDescriptionViews() {
        
        for (index,stackView) in arrayTrackDescriptionStackViews.enumerated() {
            
            if index == 0 {
                
                NSLayoutConstraint.activate([
                    
                    stackView.topAnchor.constraint(equalTo: self.topAnchor),
                    stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    stackView.widthAnchor.constraint(equalToConstant: self.bounds.width - self.bounds.width / 15),
                    stackView.heightAnchor.constraint(equalToConstant: (self.bounds.size.height / 2) / CGFloat(arrayTrackDescriptionStackViews.count))
                ])
                
            }else {
                
                NSLayoutConstraint.activate([
                    
                    stackView.topAnchor.constraint(equalTo: arrayTrackDescriptionStackViews[index - 1].bottomAnchor),
                    stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    stackView.widthAnchor.constraint(equalToConstant: self.bounds.width - self.bounds.width / 15),
                    stackView.heightAnchor.constraint(equalToConstant: (self.bounds.size.height / 2) / CGFloat(arrayTrackDescriptionStackViews.count))
                ])
            }
        }
    }
    
    private func setupConstrainsForRaceShortDescriptionViews() {
        
        NSLayoutConstraint.activate([
            
            firstPlaceImageView.topAnchor.constraint(equalTo: arrayTrackDescriptionStackViews.last!.bottomAnchor, constant: 0),
            firstPlaceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            firstPlaceImageView.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / numberOfDriversToShow),
            firstPlaceImageView.widthAnchor.constraint(equalToConstant: (self.bounds.width / 4) - 2),
            
            secondPlaceImageView.topAnchor.constraint(equalTo: firstPlaceImageView.bottomAnchor),
            secondPlaceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            secondPlaceImageView.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / numberOfDriversToShow),
            secondPlaceImageView.widthAnchor.constraint(equalToConstant: (self.bounds.width / 4) - 2),
            
            thirdPlaceImageView.topAnchor.constraint(equalTo: secondPlaceImageView.bottomAnchor),
            thirdPlaceImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            thirdPlaceImageView.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / numberOfDriversToShow),
            thirdPlaceImageView.widthAnchor.constraint(equalToConstant: (self.bounds.width / 4) - 2)
        ])
        
                
        NSLayoutConstraint.activate([

            firstPlaceSV.centerYAnchor.constraint(equalTo: firstPlaceImageView.centerYAnchor),
            firstPlaceSV.leadingAnchor.constraint(equalTo: firstPlaceImageView.trailingAnchor, constant: 5),
            firstPlaceSV.widthAnchor.constraint(equalToConstant: self.bounds.width - self.bounds.width / 3),
            firstPlaceSV.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / numberOfDriversToShow),
            
            secondPlaceSV.centerYAnchor.constraint(equalTo: secondPlaceImageView.centerYAnchor),
            secondPlaceSV.leadingAnchor.constraint(equalTo: secondPlaceImageView.trailingAnchor, constant: 5),
            secondPlaceSV.widthAnchor.constraint(equalToConstant: self.bounds.width - self.bounds.width / 3),
            secondPlaceSV.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / numberOfDriversToShow),
            
            thirdPlaceSV.centerYAnchor.constraint(equalTo: thirdPlaceImageView.centerYAnchor),
            thirdPlaceSV.leadingAnchor.constraint(equalTo: thirdPlaceImageView.trailingAnchor, constant: 5),
            thirdPlaceSV.widthAnchor.constraint(equalToConstant: self.bounds.width - self.bounds.width / 3),
            thirdPlaceSV.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / numberOfDriversToShow),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: secondPlaceImageView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    //MARK: Supporting methods
    
    private func labelsForPage(firstLabelText: String?, secondLabelText: String, fontSize: CGFloat) -> [UILabel] {
        
        let firstLabel = UILabel(text: firstLabelText, fontSize: fontSize, textAlignment: .left)
        let secondLabel = UILabel(text: secondLabelText, fontSize: fontSize, textAlignment: .right)
        
        return [firstLabel, secondLabel]
    }
    
    private func createImageView(imageName: String) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        guard let image = UIImage(named: imageName) else { return imageView }
        imageView.image = image
        return imageView
    }
}






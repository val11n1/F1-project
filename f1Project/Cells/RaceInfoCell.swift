//
//  RaceInfoCell.swift
//  f1Project
//
//  Created by Valeriy Trusov on 06.04.2022.
//

import Foundation
import UIKit


class RaceInfoCell: BaseTableViewCell {
    
    var statStackViewHeightConstraint: NSLayoutConstraint!
    
    let showStatImageView: UIImageView = {
        
        let view = UIImageView()
        view.image = UIImage(named: "down")!
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let raceTimeLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let finishStatusLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let teamNameLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pointsLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    let qualificationPosLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fastestLapLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fastestLapTimeLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fastestLapRankLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fastestLapAvgSpeedLabel: UILabel = {
        
        let label = UILabel(text: nil, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        
        self.selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [qualificationPosLabel, fastestLapLabel, fastestLapTimeLabel, fastestLapRankLabel, fastestLapAvgSpeedLabel], spacing: 0, axis: .vertical, distribution: .equalSpacing)
        statStackViewHeightConstraint = NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        stackView.addConstraint(statStackViewHeightConstraint)
        
        self.addSubview(nameLabel)
        self.addSubview(teamNameLabel)
        self.addSubview(standingLabel)
        self.addSubview(showStatImageView)
        self.addSubview(raceTimeLabel)
        self.addSubview(finishStatusLabel)
        self.addSubview(pointsLabel)
        self.addSubview(borderView)
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
        
            standingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            standingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            standingLabel.heightAnchor.constraint(equalToConstant: 50),
            standingLabel.widthAnchor.constraint(equalToConstant: 35),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: standingLabel.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.widthAnchor.constraint(equalToConstant: self.bounds.width / 2),
            
            teamNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            teamNameLabel.leadingAnchor.constraint(equalTo: standingLabel.trailingAnchor),
            teamNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: -20),
            teamNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            showStatImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            showStatImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 65),
            showStatImageView.heightAnchor.constraint(equalToConstant: 20),
            
            raceTimeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            raceTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
            raceTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 3),
            raceTimeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            finishStatusLabel.topAnchor.constraint(equalTo: raceTimeLabel.bottomAnchor),
            finishStatusLabel.heightAnchor.constraint(equalToConstant: 40),
            finishStatusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            finishStatusLabel.widthAnchor.constraint(equalToConstant: 60),

            pointsLabel.topAnchor.constraint(equalTo: raceTimeLabel.bottomAnchor),
            pointsLabel.leadingAnchor.constraint(equalTo: raceTimeLabel.leadingAnchor),
            pointsLabel.trailingAnchor.constraint(equalTo: finishStatusLabel.leadingAnchor),
            pointsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            borderView.heightAnchor.constraint(equalToConstant: 3),
            
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
        
    func configure(raceResultModel: DriverRaceResult, isChosenCell: Bool) {
        
        nameLabel.text = raceResultModel.driverFirstName + " " + raceResultModel.driverLastName
        standingLabel.text = "#" + raceResultModel.position
        raceTimeLabel.text = raceResultModel.raceTime
        pointsLabel.text = "Points: " + raceResultModel.points
        teamNameLabel.text = raceResultModel.constructorName
        
        qualificationPosLabel.text = raceResultModel.qualifyingPosition == "0" ? "Position in qualification: -": "Position in qualification: \(raceResultModel.qualifyingPosition)"
        fastestLapLabel.text = "Fastest lap"
        fastestLapTimeLabel.text = raceResultModel.fastesLapTime == nil ? "Time: -": "Time: \(raceResultModel.fastesLapTime!)"
        fastestLapRankLabel.text = raceResultModel.fastesLapTime == nil ? "Rank: -": "Rank: \(raceResultModel.fastesLapRank!)"
        fastestLapAvgSpeedLabel.text = raceResultModel.fastesLapTime == nil ? "Average speed: -": "Average speed: \(raceResultModel.fastesLapAvrSpeed!) km/h"
        
        if raceResultModel.finishStatus == "Finished" || raceResultModel.finishStatus.contains("Lap") {
            
            finishStatusLabel.text = "Finished"
            finishStatusLabel.textColor = .green
        }else {
            
            finishStatusLabel.text = "out"
            finishStatusLabel.textColor = .orange
        }
        
        if isChosenCell {
            
            showStatImageView.image = UIImage(named: "up")
            statStackViewHeightConstraint.constant = 150
            
        }else {
            
            showStatImageView.image = UIImage(named: "down")
            statStackViewHeightConstraint.constant = 0
        }
    }
}

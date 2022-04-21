//
//  RaceCell.swift
//  f1Project
//
//  Created by Valeriy Trusov on 01.04.2022.
//

import Foundation
import UIKit


class RaceCell: BaseTableViewCell {
    
    
    
    let completionImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    
    override func setupView() {
        
        self.addSubview(nameLabel)
        self.addSubview(completionImageView)
        self.addSubview(dateLabel)
        NSLayoutConstraint.activate([
        
            completionImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            completionImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            completionImageView.widthAnchor.constraint(equalToConstant: 25),
            completionImageView.heightAnchor.constraint(equalToConstant: 25),
            
            nameLabel.leadingAnchor.constraint(equalTo: completionImageView.trailingAnchor, constant: 5),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: self.frame.width - self.frame.width / 3),
            nameLabel.heightAnchor.constraint(equalToConstant: 45),
            
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 3),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            dateLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
    
    func configure(raceModel: RaceModel, isCurrentRace:inout Bool) -> Bool {
        
        self.accessoryType = .disclosureIndicator
        nameLabel.text = raceModel.name
        nameLabel.textAlignment = .left
        
        dateForDateLabel(raceModel: raceModel)
        let image = imageForRacewith(model: raceModel, iScurrentRace: &isCurrentRace)
        
        completionImageView.image = image
        
        if image == UIImage(named: "next")! {
            
            return true
        }else {
            
            return false
        }
    }
    
    private func imageForRacewith(model: RaceModel, iScurrentRace: inout Bool) -> UIImage {
        
        var image = UIImage()
        
        let date = model.raceDateWithOffset()
        
        let currentDate = Date().returnCurrentDate()
        
        if date > currentDate {
            
            if iScurrentRace == false {
                
                iScurrentRace = true
                image = UIImage(named: "next")!
                
            }else {
                
                image = UIImage(named: "soon")!
            }
        }else {
            
            image = UIImage(named: "done")!
        }
        
        return image
    }
    
    private func dateForDateLabel(raceModel: RaceModel) {
        
        let dateFormatter = DateFormatter()
        
        let raceDate = raceModel.dateFromEvent(event: .race)
        let firstPracticeDate = raceModel.dateFromEvent(event: .firstPractice)
        
        dateFormatter.dateFormat = "dd.MM"
        let raceDateString = dateFormatter.string(from: raceDate)
        let practiceDateString = dateFormatter.string(from: firstPracticeDate)
        
        dateLabel.text = "\(practiceDateString) - \(raceDateString)"
    }
}

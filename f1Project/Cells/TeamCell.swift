//
//  TeamCell.swift
//  f1Project
//
//  Created by Valeriy Trusov on 24.03.2022.
//

import Foundation
import UIKit


class TeamCell: BaseCellClass {
    
    var carImageConstraint: NSLayoutConstraint!
    
    let pointsLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    let showCarImageView: UIImageView = {
        
        let view = UIImageView()
        view.image = UIImage(named: "down")!
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let winsLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backGroundView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let carImageView: UIImageView = {
        
        let view = UIImageView()
        //view.backgroundColor = .gray.withAlphaComponent(0.6)
        view.contentMode = .scaleAspectFit
        
        let width = UIScreen.main.bounds.width
        view.layer.cornerRadius = width / 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let teamImageView: UIImageView = {
        
        let view = UIImageView()
        //view.backgroundColor = .gray.withAlphaComponent(0.6)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "RedBull")
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let carImagesDictionary: [String: UIImage] = {
        
        let dict = ["Alpine F1 Team": UIImage(named: "Alpine")!,
                    "Ferrari": UIImage(named: "Ferrari")!,
                    "Mercedes": UIImage(named: "Mercedes")!,
                    "Red Bull": UIImage(named: "Redbull")!,
                    "Haas F1 Team": UIImage(named: "Haas")!,
                    "Alfa Romeo": UIImage(named: "Alfaromeo")!,
                    "McLaren": UIImage(named: "Mclaren")!,
                    "AlphaTauri": UIImage(named: "Alphatauri")!,
                    "Aston Martin": UIImage(named: "AstonMartin")!,
                    "Williams": UIImage(named: "Williams")!]
        return dict
    }()
    
    let TeamLogoDictionary: [String: UIImage] = {
        
        let dict = ["Alpine F1 Team": UIImage(named: "alpine")!,
                    "Ferrari": UIImage(named: "ferrari")!,
                    "Mercedes": UIImage(named: "mercedes")!,
                    "Red Bull": UIImage(named: "redbull")!,
                    "Haas F1 Team": UIImage(named: "haas")!,
                    "Alfa Romeo": UIImage(named: "alfaromeo")!,
                    "McLaren": UIImage(named: "mclaren")!,
                    "AlphaTauri": UIImage(named: "alphatauri")!,
                    "Aston Martin": UIImage(named: "astonmartin")!,
                    "Williams": UIImage(named: "williams")!]
        return dict
    }()

    
    override func setupViews() {
        
        super.setupViews()
        
        self.addSubview(backGroundView)
        NSLayoutConstraint.activate([
        
            backGroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backGroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        nameLabel.font = UIFont(descriptor: description!, size: 20)
        
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -2),
            nameLabel.widthAnchor.constraint(equalToConstant: 170),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
       carImageConstraint = (NSLayoutConstraint(item: carImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
        carImageView.addConstraint(carImageConstraint)
        
        self.addSubview(carImageView)
        NSLayoutConstraint.activate([
            //carImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            carImageView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -2),
            carImageView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor, constant: 2),
            carImageView.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: -2)
        ])
        
        self.addSubview(standingLabel)
        NSLayoutConstraint.activate([
        
            standingLabel.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 20),
            standingLabel.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor, constant: 5),
            standingLabel.widthAnchor.constraint(equalToConstant: 50),
            standingLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        self.addSubview(teamImageView)
        NSLayoutConstraint.activate([
        
            teamImageView.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 20),
            teamImageView.leadingAnchor.constraint(equalTo: standingLabel.trailingAnchor, constant: 2),
            teamImageView.widthAnchor.constraint(equalToConstant: 80),
            teamImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [pointsLabel, winsLabel], spacing: 0, axis: .horizontal, distribution: .fillProportionally)
        
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
        
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalToConstant: 170),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.addSubview(showCarImageView)
        NSLayoutConstraint.activate([
        
            showCarImageView.topAnchor.constraint(equalTo: teamImageView.bottomAnchor, constant: -25),
            showCarImageView.centerXAnchor.constraint(equalTo: backGroundView.centerXAnchor),
            showCarImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(teamModel: TeamModel, isChosenTeam: Bool) {
        
        nameLabel.text = teamModel.name
        standingLabel.text = "#" + teamModel.position
        pointsLabel.text = "Points: \(teamModel.points)"
        winsLabel.text = "Wins: \(teamModel.wins)"
        
        if let image = carImagesDictionary[teamModel.name] {
            
            carImageView.image = image
        }
        
        if let image = TeamLogoDictionary[teamModel.name] {
            
            teamImageView.image = image
        }
        
        if isChosenTeam {
            
            self.showCarImageView.image = UIImage(named: "up")!
            self.carImageConstraint.constant = 150
        }else {
            
            self.showCarImageView.image = UIImage(named: "down")!
            self.carImageConstraint.constant = 0
        }
    }
}

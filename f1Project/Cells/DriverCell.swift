//
//  DriverCell.swift
//  f1Project
//
//  Created by Valeriy Trusov on 23.03.2022.
//

import Foundation
import UIKit


class DriverCell: BaseCellClass {
    
    let driverDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let teamLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Team:"
        label.textAlignment = .right
        return label
    }()

    let teamNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        let descriptor = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: descriptor!, size: 14)
        label.textAlignment = .center
        return label
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    let imageDriverDictionary: [String: UIImage] = {
        
        let dict = ["leclerc": UIImage(named: "leclerc")!,
                    "sainz": UIImage(named: "sainz")!,
                    "hamilton": UIImage(named: "hamilton")!,
                    "russell": UIImage(named: "russell")!,
                    "kevin_magnussen": UIImage(named: "magnussen")!,
                    "bottas": UIImage(named: "bottas")!,
                    "ocon": UIImage(named: "ocon")!,
                    "tsunoda": UIImage(named: "tsunoda")!,
                    "alonso": UIImage(named: "alonso")!,
                    "zhou": UIImage(named: "zhou")!,
                    "mick_schumacher": UIImage(named: "schumacher")!,
                    "stroll": UIImage(named: "stroll")!,
                    "albon": UIImage(named: "albon")!,
                    "ricciardo": UIImage(named: "ricciardo")!,
                    "norris": UIImage(named: "norris")!,
                    "latifi": UIImage(named: "latifi")!,
                    "hulkenberg": UIImage(named: "hulkenberg")!,
                    "perez": UIImage(named: "perez")!,
                    "max_verstappen": UIImage(named: "verstappen")!,
                    "gasly": UIImage(named: "gasly")!,
                    "vettel": UIImage(named: "vettel")!]
        return dict
    }()
    
    let imageCountryDictionary: [String: UIImage] = {
        
        let dict = ["Monegasque": UIImage(named: "Monegasque")!,
                    "Spanish": UIImage(named: "Spanish")!,
                    "British": UIImage(named: "British")!,
                    "Danish": UIImage(named: "Danish")!,
                    "Finnish": UIImage(named: "Finnish")!,
                    "French": UIImage(named: "French")!,
                    "Japanese": UIImage(named: "Japanese")!,
                    "Chinese": UIImage(named: "Chinese")!,
                    "German": UIImage(named: "German")!,
                    "Canadian": UIImage(named: "Canadian")!,
                    "Thai": UIImage(named: "Thai")!,
                    "Australian": UIImage(named: "Australian")!,
                    "Mexican": UIImage(named: "Mexican")!,
                    "Dutch": UIImage(named: "Dutch")!]
        return dict
    }()

    
    
    let driverImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let countryImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
   override func setupViews() {
        super.setupViews()
       
       self.addSubview(standingLabel)
       NSLayoutConstraint.activate([
       
        standingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        standingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
        standingLabel.widthAnchor.constraint(equalToConstant: 50),
        standingLabel.heightAnchor.constraint(equalToConstant: 50)
       ])
       
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
       
       self.addSubview(driverDescription)
       NSLayoutConstraint.activate([
       
           driverDescription.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
           driverDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
           driverDescription.widthAnchor.constraint(equalToConstant: 150),
           driverDescription.heightAnchor.constraint(equalToConstant: 30)
       ])
       
       let stackView = UIStackView(arrangedSubviews: [teamLabel, teamNameLabel], spacing: 0, axis: .horizontal, distribution: .fillProportionally)

       self.addSubview(stackView)
       NSLayoutConstraint.activate([

        stackView.topAnchor.constraint(equalTo: driverDescription.bottomAnchor),
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        stackView.widthAnchor.constraint(equalToConstant: 170),
        stackView.heightAnchor.constraint(equalToConstant: 30)
       ])
       
        
        self.addSubview(driverImageView)
        NSLayoutConstraint.activate([
        
            driverImageView.leadingAnchor.constraint(equalTo: standingLabel.trailingAnchor, constant: 5),
            driverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            driverImageView.widthAnchor.constraint(equalToConstant: 70),
            driverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:  -5)
        ])
       
       self.addSubview(borderView)
       NSLayoutConstraint.activate([

           borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
           borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
           borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
           borderView.heightAnchor.constraint(equalToConstant: 2)
       ])
       
       self.addSubview(countryImageView)
       NSLayoutConstraint.activate([
       
           countryImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
           countryImageView.heightAnchor.constraint(equalToConstant: 30),
           countryImageView.widthAnchor.constraint(equalToConstant: 30),
           countryImageView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor)
       ])

    }
    
    func configure(driverModel: DriverModel) {
        
        nameLabel.text = driverModel.firstName + " " + driverModel.lastName
        standingLabel.text = "#" + driverModel.position
        //driverDescription.text = "Driver's number: \(driverModel.permanentNumber)  Points: \(driverModel.points)"
        driverDescription.text = "Points: \(driverModel.points)"
        teamNameLabel.text = driverModel.teamName.uppercased()

        if let driverImage = imageDriverDictionary[driverModel.driverId] {
            
            driverImageView.image = driverImage
        }
        
        if let countryImage = imageCountryDictionary[driverModel.nationality] {
            
            countryImageView.image = countryImage
        }
    }
}

//MARK: Base class cell

class BaseCellClass: UICollectionViewCell {
    
    
    let standingLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 20)
        return label
    }()

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    }
}



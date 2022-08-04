//
//  FirstPageView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


class FirstPageView: UIView, FirstPageViewProtocol {
    
    var raceImageView: UIImageView!
    
    var firstLabel: UILabel!
    var firstLabelDescription: UILabel!
    
    var secondLabel: UILabel!
    var secondLabelDescription: UILabel!
    
    var thirdLabel: UILabel!
    var thirdLabelDescription: UILabel!
    
    var fourthLabel: UILabel!
    var fourthLabelDescription: UILabel!
    
    var fifthLabel: UILabel!
    var fifthLabelDescription: UILabel!
    
    private var arrayStackViews: [UIStackView]!
    
    required init(frame: CGRect, raceInfoModel: RaceModel) {
        super.init(frame: frame)
        setupPageView()
        setupConstrains()
        labelsConfigure(raceInfoModel: raceInfoModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPageView() {
        
        self.backgroundColor = .black
        
        raceImageView = UIImageView()
        raceImageView.backgroundColor = .white
        raceImageView.layer.cornerRadius = 15
        raceImageView.contentMode = .scaleAspectFit
        raceImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(raceImageView)
        
        firstLabel = createLabelForPageView(alignment: .left)
        firstLabelDescription = createLabelForPageView(alignment: .right)

        secondLabel = createLabelForPageView(alignment: .left)
        secondLabelDescription = createLabelForPageView(alignment: .right)

        thirdLabel = createLabelForPageView(alignment: .left)
        thirdLabelDescription = createLabelForPageView(alignment: .right)

        fourthLabel = createLabelForPageView(alignment: .left)
        fourthLabelDescription = createLabelForPageView(alignment: .right)

        fifthLabel = createLabelForPageView(alignment: .left)
        fifthLabelDescription = createLabelForPageView(alignment: .right)

        let firstSw = UIStackView(arrangedSubviews: [firstLabel, firstLabelDescription], spacing: nil, axis: .horizontal, distribution: .fill)
        
        let secondSw = UIStackView(arrangedSubviews: [secondLabel, secondLabelDescription], spacing: nil, axis: .horizontal, distribution: .fill)
        let thirdSw = UIStackView(arrangedSubviews: [thirdLabel, thirdLabelDescription], spacing: nil, axis: .horizontal, distribution: .fill)
        let fourthSw = UIStackView(arrangedSubviews: [fourthLabel, fourthLabelDescription], spacing: nil, axis: .horizontal, distribution: .fill)
        let fifthSw = UIStackView(arrangedSubviews: [fifthLabel, fifthLabelDescription], spacing: nil, axis: .horizontal, distribution: .fill)
        
        arrayStackViews = [firstSw, secondSw, thirdSw, fourthSw, fifthSw]
        
        for stackView in arrayStackViews {
            
            self.addSubview(stackView)
        }
        
    }
    
    private func setupConstrains() {
        
        
        NSLayoutConstraint.activate([
            
            raceImageView.topAnchor.constraint(equalTo: self.topAnchor),
            raceImageView.widthAnchor.constraint(equalToConstant: self.frame.size.width),
            raceImageView.heightAnchor.constraint(equalToConstant: self.bounds.height / 2)
        ])
        
        for (index, sv) in arrayStackViews.enumerated() {
            
            if index == 0 {
                
                NSLayoutConstraint.activate([
                    
                    sv.topAnchor.constraint(equalTo: raceImageView.bottomAnchor),
                    sv.widthAnchor.constraint(equalToConstant: self.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / 5)
                ])
                
            }else {
                
                NSLayoutConstraint.activate([
                    
                    sv.topAnchor.constraint(equalTo: arrayStackViews[index - 1].bottomAnchor),
                    sv.widthAnchor.constraint(equalToConstant: self.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (self.bounds.height / 2) / 5)
                ])
            }
        }
    }
    
    private func labelsConfigure(raceInfoModel: RaceModel) {
        
        if let trackImage = RaceInfoParams.raceInfoDict[raceInfoModel.name]?.image {
            
            raceImageView.image = trackImage
        }
        
        firstLabel.text = "First practice"
        dateAndTimeForEvent(date: raceInfoModel.firstPractice.date, time: raceInfoModel.firstPractice.time, viewForText: firstLabelDescription)
        
        fifthLabel.text = "Race"
        dateAndTimeForEvent(date: raceInfoModel.date, time: raceInfoModel.time, viewForText: fifthLabelDescription)
        
        if raceInfoModel.sprint != nil {
            
            secondLabel.text = "Qualifying"
            dateAndTimeForEvent(date: raceInfoModel.qualifying.date, time: raceInfoModel.qualifying.time, viewForText: secondLabelDescription)
            
            thirdLabel.text = "Second practice"
            dateAndTimeForEvent(date: raceInfoModel.secondPractice.date, time: raceInfoModel.secondPractice.time, viewForText: thirdLabelDescription)
            
            fourthLabel.text = "Sprint"
            dateAndTimeForEvent(date: raceInfoModel.sprint!.date, time: raceInfoModel.sprint!.time, viewForText: fourthLabelDescription)
        }else {
            
            secondLabel.text = "Second practice"
            dateAndTimeForEvent(date: raceInfoModel.secondPractice.date, time: raceInfoModel.secondPractice.time, viewForText: secondLabelDescription)
            
            thirdLabel.text = "Third practice"
            dateAndTimeForEvent(date: raceInfoModel.thirdPractice!.date, time: raceInfoModel.thirdPractice!.time, viewForText: thirdLabelDescription)
            
            fourthLabel.text = "Qualifying"
            dateAndTimeForEvent(date: raceInfoModel.qualifying.date, time: raceInfoModel.qualifying.time, viewForText: fourthLabelDescription)
        }
    }
    
    private func createLabelForPageView(alignment: NSTextAlignment) -> UILabel {
        return UILabel.init(text: nil, fontSize: 14, textAlignment: alignment)
    }
    
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

//
//  FirstPageView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


class FirstPageViewSetup: UIView {
    
    
    static func setupPageView(pageView: UIView, raceInfoModel: RaceModel, contentSizeHeight: CGFloat) {
        
            //firstPageActivityIndicatorSetup()

            let raceImageView = UIImageView()

        if let image = RaceInfoParams.raceInfoDict[raceInfoModel.name]?.image {

                    raceImageView.image = image
                }

            raceImageView.backgroundColor = .white
            raceImageView.layer.cornerRadius = 15
            raceImageView.contentMode = .scaleAspectFit
            raceImageView.translatesAutoresizingMaskIntoConstraints = false

            pageView.addSubview(raceImageView)
            NSLayoutConstraint.activate([

                raceImageView.topAnchor.constraint(equalTo: pageView.topAnchor),
                raceImageView.widthAnchor.constraint(equalToConstant: pageView.frame.size.width),
                raceImageView.heightAnchor.constraint(equalToConstant: contentSizeHeight / 2)
            ])

            let firstPracticeLabel = UILabel.init(text: "First Practice", fontSize: 15, textAlignment: .left)
            let firstPracticeDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)

            let secondPracticeLabel = UILabel.init(text: "Second Practice", fontSize: 15, textAlignment: .left)
            let secondPracticeDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)

            let qualifyingLabel = UILabel.init(text: "Qualifying", fontSize: 15, textAlignment: .left)
            let qualifyingDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)

            let raceLabel = UILabel.init(text: "Race", fontSize: 15, textAlignment: .left)
            let raceDescriptionLabel = UILabel.init(text: nil, fontSize: 15, textAlignment: .right)

        DateForEventParser.dateAndTimeForEvent(date: raceInfoModel.firstPractice.date, time: raceInfoModel.firstPractice.time, viewForText: firstPracticeDescriptionLabel)
        DateForEventParser.dateAndTimeForEvent(date: raceInfoModel.secondPractice.date, time: raceInfoModel.secondPractice.time, viewForText: secondPracticeDescriptionLabel)
        DateForEventParser.dateAndTimeForEvent(date: raceInfoModel.qualifying.date, time: raceInfoModel.qualifying.time, viewForText: qualifyingDescriptionLabel)
        DateForEventParser.dateAndTimeForEvent(date: raceInfoModel.date, time: raceInfoModel.time, viewForText: raceDescriptionLabel)

            let firstSw = UIStackView(arrangedSubviews: [firstPracticeLabel, firstPracticeDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)

            let secondSw = UIStackView(arrangedSubviews: [secondPracticeLabel, secondPracticeDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
            let qualifyingSw = UIStackView(arrangedSubviews: [qualifyingLabel, qualifyingDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)
            let raceSw = UIStackView(arrangedSubviews: [raceLabel, raceDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)

            var arrayViews = [UIStackView]()

            if raceInfoModel.sprint != nil {

                let sprintLabel = UILabel.init(text: "Sprint", fontSize: 15, textAlignment: .left)
                let sprintDescriptionLabel = UILabel(text: nil, fontSize: 15, textAlignment: .right)
                let sprintSW = UIStackView(arrangedSubviews: [sprintLabel, sprintDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)

                DateForEventParser.dateAndTimeForEvent(date: raceInfoModel.sprint!.date, time: raceInfoModel.sprint!.time, viewForText: sprintDescriptionLabel)

                arrayViews = [firstSw, qualifyingSw, secondSw, sprintSW, raceSw]

            }else {

                let tpLabel = UILabel.init(text: "Third practice", fontSize: 15, textAlignment: .left)
                let tpDescriptionLabel = UILabel(text: nil, fontSize: 15, textAlignment: .right)
                let tpStackView = UIStackView(arrangedSubviews: [tpLabel, tpDescriptionLabel], spacing: nil, axis: .horizontal, distribution: .fill)

                DateForEventParser.dateAndTimeForEvent(date: raceInfoModel.thirdPractice!.date, time: raceInfoModel.thirdPractice!.time, viewForText: tpDescriptionLabel)

                arrayViews = [firstSw, secondSw, tpStackView, qualifyingSw, raceSw]
            }


            for (index, sv) in arrayViews.enumerated() {

                pageView.addSubview(sv)

                if index == 0 {

                    NSLayoutConstraint.activate([

                        sv.topAnchor.constraint(equalTo: raceImageView.bottomAnchor),
                        sv.widthAnchor.constraint(equalToConstant: pageView.bounds.width),
                        sv.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / 5)
                    ])

                }else {

                    NSLayoutConstraint.activate([

                    sv.topAnchor.constraint(equalTo: arrayViews[index - 1].bottomAnchor),
                    sv.widthAnchor.constraint(equalToConstant: pageView.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / 5)
                      ])
                }
            }
          }
}

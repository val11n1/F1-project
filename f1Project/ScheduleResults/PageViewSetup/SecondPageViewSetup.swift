//
//  SecondPageViewSetup.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


class SecondPageViewSetup {
    
    static func setupPageView(pageView: UIView, raceInfoModel: RaceModel, contentSizeHeight: CGFloat) {
        
        let stackViewsCount: CGFloat = 4
        
        let raceInfo = RaceInfoParams.raceInfoDict[raceInfoModel.name]!
        
        let placeLabels = labelsForPage(firstLabelText: "Place", secondLabelText: "\(raceInfoModel.locality), \(raceInfoModel.country)")
        let lapsContLabels = labelsForPage(firstLabelText: "Laps", secondLabelText: "\(raceInfo.laps)")
        let oneLapLabels = labelsForPage(firstLabelText: "1 lap distance", secondLabelText: "\(raceInfo.lapDistance)m")
        let raceDistanceLabels = labelsForPage(firstLabelText: "Distance", secondLabelText: "\(raceInfo.distance)km")
        
        let placeSV = UIStackView(arrangedSubviews: placeLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let lapCountSV = UIStackView(arrangedSubviews: lapsContLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let oneLapSV = UIStackView(arrangedSubviews: oneLapLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        let raceDistanceSV = UIStackView(arrangedSubviews: raceDistanceLabels, spacing: 0, axis: .horizontal, distribution: .fill)
        //raceDistanceStackView = raceDistanceSV
        
        let arraySV = [placeSV, lapCountSV, oneLapSV, raceDistanceSV]
        
        for (index, sv) in arraySV.enumerated() {
            
            pageView.addSubview(sv)

            if index == 0 {
                
                NSLayoutConstraint.activate([
                
                    sv.topAnchor.constraint(equalTo: pageView.topAnchor),
                    sv.widthAnchor.constraint(equalToConstant: pageView.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / stackViewsCount)
                ])
                
            }else {
                
                NSLayoutConstraint.activate([
                
                    sv.topAnchor.constraint(equalTo: arraySV[index - 1].bottomAnchor),
                    sv.widthAnchor.constraint(equalToConstant: pageView.bounds.width),
                    sv.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / stackViewsCount)
                ])
                
            }
        }
    }
    
   static private func labelsForPage(firstLabelText: String?, secondLabelText: String) -> [UILabel] {
        
        let firstLabel = UILabel(text: firstLabelText, fontSize: 18, textAlignment: .left)
        let secondLabel = UILabel(text: secondLabelText, fontSize: 18, textAlignment: .right)
        
        return [firstLabel, secondLabel]
    }
    
    static func firstThreeDriversSetup(pageView: UIView, contentSizeHeight: CGFloat) -> ((
        firstPlaceDriverLabel:UILabel,
        firstPlaceTeamLabel: UILabel,
        secondPlaceDriverLabel: UILabel,
        secondPlaceTeamLabel: UILabel,
        thirdPlaceDriverLabel: UILabel,
        thirdPlaceTeamLabel: UILabel)) {
        
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
        
        let firstPlaceDriverLabel = UILabel(text: nil, fontSize: 15)
        let firstPlaceTeamLabel = UILabel(text: nil, fontSize: 15)
        
        let secondPlaceDriverLabel = UILabel(text: nil, fontSize: 15)
        let secondPlaceTeamLabel = UILabel(text: nil, fontSize: 15)
        
        let thirdPlaceDriverLabel = UILabel(text: nil, fontSize: 15)
        let thirdPlaceTeamLabel = UILabel(text: nil, fontSize: 15)
        
        let returnedTupple = (firstPlaceDriverLabel,
                              firstPlaceTeamLabel,
                              secondPlaceDriverLabel,
                              secondPlaceTeamLabel,
                              thirdPlaceDriverLabel,
                              thirdPlaceTeamLabel)
    
        let firstPlaceSV = UIStackView(arrangedSubviews: [firstPlaceDriverLabel, firstPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        let secondPlaceSV = UIStackView(arrangedSubviews: [secondPlaceDriverLabel, secondPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        let thirdPlaceSV = UIStackView(arrangedSubviews: [thirdPlaceDriverLabel, thirdPlaceTeamLabel], spacing: 0, axis: .horizontal, distribution: .fill)
        
        pageView.addSubview(firstPlaceImageView)
        pageView.addSubview(firstPlaceSV)
        pageView.addSubview(secondPlaceImageView)
        pageView.addSubview(secondPlaceSV)
        pageView.addSubview(thirdPlaceSV)
        pageView.addSubview(thirdPlaceImageView)
        
        let elemenInStackViewCount: CGFloat = 3
        
        NSLayoutConstraint.activate([
        
            firstPlaceImageView.topAnchor.constraint(equalTo: pageView.topAnchor, constant: contentSizeHeight / 2),
            firstPlaceImageView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 2),
            firstPlaceImageView.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / elemenInStackViewCount),
            firstPlaceImageView.widthAnchor.constraint(equalToConstant: (pageView.bounds.width / 4) - 2),
            
            firstPlaceSV.topAnchor.constraint(equalTo: pageView.topAnchor, constant: contentSizeHeight / 2),
            firstPlaceSV.leadingAnchor.constraint(equalTo: firstPlaceImageView.trailingAnchor, constant: 5),
            firstPlaceSV.widthAnchor.constraint(equalToConstant: pageView.bounds.width - pageView.bounds.width / 3),
            firstPlaceSV.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / elemenInStackViewCount),
            
            secondPlaceImageView.topAnchor.constraint(equalTo: firstPlaceImageView.bottomAnchor),
            secondPlaceImageView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 2),
            secondPlaceImageView.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / elemenInStackViewCount),
            secondPlaceImageView.widthAnchor.constraint(equalToConstant: (pageView.bounds.width / 4) - 2),
            
            secondPlaceSV.topAnchor.constraint(equalTo: firstPlaceSV.bottomAnchor),
            secondPlaceSV.leadingAnchor.constraint(equalTo: secondPlaceImageView.trailingAnchor, constant: 5),
            secondPlaceSV.widthAnchor.constraint(equalToConstant: pageView.bounds.width - pageView.bounds.width / 3),
            secondPlaceSV.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / elemenInStackViewCount),
            
            thirdPlaceImageView.topAnchor.constraint(equalTo: secondPlaceImageView.bottomAnchor),
            thirdPlaceImageView.leadingAnchor.constraint(equalTo: pageView.leadingAnchor, constant: 2),
            thirdPlaceImageView.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / elemenInStackViewCount),
            thirdPlaceImageView.widthAnchor.constraint(equalToConstant: (pageView.bounds.width / 4) - 2),
            
            thirdPlaceSV.topAnchor.constraint(equalTo: secondPlaceSV.bottomAnchor),
            thirdPlaceSV.leadingAnchor.constraint(equalTo: thirdPlaceImageView.trailingAnchor, constant: 5),
            thirdPlaceSV.widthAnchor.constraint(equalToConstant: pageView.bounds.width - pageView.bounds.width / 3),
            thirdPlaceSV.heightAnchor.constraint(equalToConstant: (contentSizeHeight / 2) / elemenInStackViewCount)
        ])
        return returnedTupple
    }
    
}

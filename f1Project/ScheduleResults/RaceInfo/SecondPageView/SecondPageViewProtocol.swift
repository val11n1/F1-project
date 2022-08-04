//
//  SecondPageViewProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 03.08.2022.
//

import UIKit


protocol SecondPageViewProtocol {
    
    var firstPlaceImageView:  UIImageView! { get }
    var secondPlaceImageView: UIImageView! { get }
    var thirdPlaceImageView:  UIImageView! { get }
    
    var firstPlaceDriverLabel:  UILabel!   { get }
    var firstPlaceTeamLabel:    UILabel!   { get }
    
    var secondPlaceDriverLabel: UILabel!   { get }
    var secondPlaceTeamLabel:   UILabel!   { get }
    
    var thirdPlaceDriverLabel:  UILabel!   { get }
    var thirdPlaceTeamLabel:    UILabel!   { get }
    
    func shortDescriptionFrom(raceResult: [DriverRaceResult])
    func shortDescriptionWithoutRaceResult()
}

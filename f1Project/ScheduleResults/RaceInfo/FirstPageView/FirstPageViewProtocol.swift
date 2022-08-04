//
//  FirstPageViewProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 03.08.2022.
//

import UIKit


protocol FirstPageViewProtocol {
    
    var raceImageView: UIImageView!       { get }
    
    var firstLabel: UILabel!              { get }
    var firstLabelDescription: UILabel!   { get }
    
    var secondLabel: UILabel!             { get }
    var secondLabelDescription: UILabel!  { get }
    
    var thirdLabel: UILabel!              { get }
    var thirdLabelDescription: UILabel!   { get }
    
    var fourthLabel: UILabel!             { get }
    var fourthLabelDescription: UILabel!  { get }
    
    var fifthLabel: UILabel!              { get }
    var fifthLabelDescription: UILabel!   { get }
}

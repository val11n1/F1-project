//
//  StackView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 27.03.2022.
//

import Foundation
import UIKit


extension UIStackView {
    
    convenience init (arrangedSubviews: [UIView], spacing: CGFloat?, axis: NSLayoutConstraint.Axis, distribution: Distribution) {
        
        self.init(arrangedSubviews: arrangedSubviews)
        
        self.axis = axis
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .center
        
        if let spacing = spacing {
            
            self.spacing = spacing
        }
    }
}

//
//  Label.swift
//  f1Project
//
//  Created by Valeriy Trusov on 04.04.2022.
//

import Foundation
import UIKit


extension UILabel {
    
    convenience init (text: String? = nil, fontSize: CGFloat, textAlignment: NSTextAlignment = .center) {
        self.init()
        textColor = .white
        self.textAlignment = textAlignment
        let descriptor = UIFontDescriptor().withSymbolicTraits(.traitBold)
        font = UIFont(descriptor: descriptor!, size: fontSize)
        self.translatesAutoresizingMaskIntoConstraints = false
        if let text = text {
            self.text = text
        }
    }
}

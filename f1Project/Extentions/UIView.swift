//
//  UIView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


extension UIView {
    
    static func initWith(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        return view
    }
}

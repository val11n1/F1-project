//
//  NewsHeaderFooterView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 30.03.2022.
//

import Foundation
import UIKit


class BaseHeaderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



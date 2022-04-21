//
//  NewsCell.swift
//  f1Project
//
//  Created by Valeriy Trusov on 30.03.2022.
//

import Foundation
import UIKit
import SwiftSoup


class NewsCell: BaseTableViewCell {
    
   
    override func setupView() {
        
        self.accessoryType = .disclosureIndicator
        
        self.addSubview(backGroundView)
        NSLayoutConstraint.activate([
        
            backGroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            backGroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            backGroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            backGroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),

        ])
        
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
        
            nameLabel.centerYAnchor.constraint(equalTo: backGroundView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configure(element: Element) {
        
        
        do {
            let text: String = try element.text()
            nameLabel.text = text
        }catch  let err {
            print(err.localizedDescription)
        }
    }
}




class BaseTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let standingLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        let description = UIFontDescriptor().withSymbolicTraits(.traitBold)
        label.font = UIFont(descriptor: description!, size: 16)
        return label
    }()

    
    let backGroundView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setupView() {
        
    }
}

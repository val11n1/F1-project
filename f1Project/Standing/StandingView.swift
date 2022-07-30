//
//  StandingView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 29.07.2022.
//

import Foundation
import UIKit


class StandingView: UIView, StandingViewProtocol {
    
    var cellDriverId = "cellDriverId"
    var cellTeamId = "cellTeamId"
    
    var activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    var segmentControl: UISegmentedControl!
    
    var collectionView: UICollectionView!
    
    init(frame: CGRect, viewController: UIViewController) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        setupViews(frame: frame,viewController: viewController)
        setupConstrains()
        self.activityIndicator.startAnimating()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Configure
    
    private func setupViews(frame: CGRect,viewController: UIViewController) {

        let cgrect = CGRect(x: 0, y: 40, width: frame.size.width, height: frame.size.height - 40)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: cgrect, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
        
        let segmentControl = UISegmentedControl(items: ["Drivers", "Teams"])
        segmentControl.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 40)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.isHidden = true
        self.segmentControl = segmentControl

        let iv = UIImageView()
        iv.image = UIImage(named: "f1logo")
        iv.contentMode = .scaleAspectFill
        collectionView.backgroundView = iv
        
        self.addSubview(self.collectionView)
        self.addSubview(self.activityIndicator)
        self.addSubview(self.segmentControl)
    }
    
    
    private func setupConstrains() {
       
        NSLayoutConstraint.activate([
        
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
}

//
//  StandingViewProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 29.07.2022.
//

import UIKit


protocol StandingViewProtocol {
    
    var cellDriverId: String { get }
    var cellTeamId: String { get }
    var activityIndicator: UIActivityIndicatorView { get }
    var segmentControl: UISegmentedControl! { get }
    var collectionView: UICollectionView! { get }
}

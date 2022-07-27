//
//  ViewController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import UIKit

class StandingCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    var reloadItemIndexPath: IndexPath?
    let cellDriverId = "cellDriverId"
    let cellTeamId = "cellTeamId"
    var viewModel: StandingViewModelProtocol?
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    let segmentControl: UISegmentedControl = {
        
        let segmentControl = UISegmentedControl(items: ["Drivers", "Teams"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.isHidden = true
        //segmentControl.sizeToFit()
        
        return segmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.3) {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        setupView()
        activityIndicator.startAnimating()
        collectionView.register(DriverCell.self, forCellWithReuseIdentifier: cellDriverId)
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: cellTeamId)
        
        segmentControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        
        self.navigationItem.titleView = segmentControl
        self.navigationItem.titleView?.frame.size = CGSize(width: self.view.frame.width, height: self.navigationItem.titleView!.frame.height)
        
        setGestures()
        
        StandingViewModel.createViewModel { [weak self] viewModel in
            
            self?.activityIndicator.stopAnimating()
            self?.segmentControl.isHidden = false
            self?.viewModel = viewModel
            self?.collectionView.reloadData()
        }

    }
    

    //MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItem(selectedSegmentIndex: segmentControl.selectedSegmentIndex) ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if segmentControl.selectedSegmentIndex == 0 {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellDriverId, for: indexPath) as! DriverCell
            
            if let driver = viewModel?.returnModelFrom(selectedSegmentIndex: segmentControl.selectedSegmentIndex, itemIndex: indexPath.item) as? DriverModel {
                cell.configure(driverModel: driver)
            }
            return cell
            
        }else {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellTeamId, for: indexPath) as! TeamCell
            
            if let team = viewModel?.returnModelFrom(selectedSegmentIndex: segmentControl.selectedSegmentIndex, itemIndex: indexPath.item) as? TeamModel {
                cell.configure(teamModel: team)
                
                    if indexPath == reloadItemIndexPath  {
                    
                        cell.showCarImageView.image = UIImage(named: "up")!
                        cell.carImageConstraint.constant = 150
                    }else {
                        cell.showCarImageView.image = UIImage(named: "down")
                        cell.carImageConstraint.constant = 0
                    }
                collectionView.layoutIfNeeded()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch viewModel != nil {
        case true:
            
            if segmentControl.selectedSegmentIndex == 0 {
                
                return CGSize(width: view.frame.width, height: 130)
                
            }else {
                
                if reloadItemIndexPath == indexPath  {
                
                return CGSize(width: view.frame.width, height: 300)
                }
                
                return CGSize(width: view.frame.width, height: 100)
            }
            
        default:
            return CGSize(width: view.frame.width, height: 44)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return segmentControl.selectedSegmentIndex == 0 ? 0: 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if segmentControl.selectedSegmentIndex == 1 {
            
            if reloadItemIndexPath == nil || reloadItemIndexPath != indexPath {
                
            reloadItemIndexPath = indexPath
                
            }else {
                
                reloadItemIndexPath = nil
            }

            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            }
        }
    }

 
    
    
    //MARK: Setup view
    
    private func setupView() {
        
        let iv = UIImageView()
        iv.image = UIImage(named: "f1logo")
        iv.contentMode = .scaleAspectFill
        //iv.tintColor = UIColor.black.withAlphaComponent(0)
        collectionView.backgroundView = iv
        
        collectionView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
        
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
//MARK: Actions
    
    @objc private func segmentAction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0  {
            
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }else if sender.selectedSegmentIndex == 1  {
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: reloadItemIndexPath == nil ? 0: reloadItemIndexPath!.item, section: 0), at: .centeredVertically, animated: false)

        }
    }
    
    //MARK: setGestures
    
    private func setGestures() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeStanding))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeStanding))
        swipeLeft.direction = .left
        
        collectionView.addGestureRecognizer(swipeRight)
        collectionView.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func swipeStanding(sender: UISwipeGestureRecognizer) {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        
        switch sender.direction {
            
        case .right:
            
            if segmentControl.selectedSegmentIndex != 0 {
            segmentControl.selectedSegmentIndex = 0
            collectionView.reloadData()
            }
            
        case .left:
            
            if segmentControl.selectedSegmentIndex != 1 {
            segmentControl.selectedSegmentIndex = 1
            collectionView.reloadData()
            }
        default: break
        }
        
    }
    
}


extension StandingCollectionViewController {
    
    //MARK: Supported orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
}

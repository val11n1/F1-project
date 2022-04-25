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
    private var arrayForModel: [Any]?
    
    let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    let dispatchQueue = DispatchQueue(label: "queueForFetchStandingsData")
    
    var driversArray: [DriverModel]? {
        
        didSet {
            arrayForModel = driversArray
            fetchTeamsArray()
        }
    }
    
    var teamsArray: [TeamModel]? {
        
        didSet {

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.segmentControl.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
    
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
        fetchDriversArray()
        //fetchTeamsArray()
        collectionView.register(DriverCell.self, forCellWithReuseIdentifier: cellDriverId)
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: cellTeamId)
        
        segmentControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        
        self.navigationItem.titleView = segmentControl
        self.navigationItem.titleView?.frame.size = CGSize(width: self.view.frame.width, height: self.navigationItem.titleView!.frame.height)
        
        setGestures()
    }
    

    //MARK: UIScrollViewDelegate, UIScrollViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch arrayForModel != nil {
        case true: return arrayForModel!.count
        default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if segmentControl.selectedSegmentIndex == 0 {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellDriverId, for: indexPath) as! DriverCell
            
            if let driver = arrayForModel?[indexPath.item] as? DriverModel {
                cell.configure(driverModel: driver)
            }
            return cell
            
        }else {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellTeamId, for: indexPath) as! TeamCell
            
            if let team = arrayForModel?[indexPath.item] as? TeamModel {
                cell.configure(teamModel: team)
                cell.carImageConstraint.constant = indexPath == reloadItemIndexPath ? 150: 0
                collectionView.layoutIfNeeded()
                cell.showCarImageView.image = UIImage(named: "down")
                
                    if indexPath == reloadItemIndexPath  {
                    
                        cell.showCarImageView.image = UIImage(named: "up")!
                        
                    }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch arrayForModel != nil {
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

    //MARK: Fetch data
    
    fileprivate func fetchDriversArray() {
       
        let queue = DispatchQueue(label: "queueForDriversArray", qos: .utility, attributes: .concurrent)
        queue.sync {
            networkingManager.shared.fetchData(type:.DriverResponce, round: nil) { [unowned self] array in
                
                if let driversArr = array as? [DriverModel] {
                    
                    self.dispatchQueue.sync {
                        self.driversArray = driversArr
                    }
                }
            }
        }
    }
    
    fileprivate func fetchTeamsArray() {
      
        let queue = DispatchQueue(label: "queueForDriversArray", qos: .utility, attributes: .concurrent)
        queue.async {
            networkingManager.shared.fetchData(type:.TeamResponce, round: nil) { array in
                
                if let teamsArr = array as? [TeamModel] {
                    
                        self.teamsArray = teamsArr
                }
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
        
        if sender.selectedSegmentIndex == 0 && driversArray != nil {
            
            arrayForModel = driversArray
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }else if sender.selectedSegmentIndex == 1 && teamsArray != nil {
            
            arrayForModel = teamsArray
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
            segmentControl.selectedSegmentIndex = 0
            arrayForModel = driversArray
            collectionView.reloadData()
        case .left:
            segmentControl.selectedSegmentIndex = 1
            arrayForModel = teamsArray
            collectionView.reloadData()
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

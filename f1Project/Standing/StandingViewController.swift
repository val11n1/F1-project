//
//  ViewController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import UIKit

class StandingViewController: UIViewController {


    var viewModel: StandingViewModelProtocol?
    var standingView: StandingViewProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.3) {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
        self.title = "Standing"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if standingView == nil {
            configureView()
            
            StandingViewModel.createViewModel { [weak self] viewModel in
                
                self?.standingView.activityIndicator.stopAnimating()
                self?.standingView.segmentControl.isHidden = false
                self?.viewModel = viewModel
                self?.standingView.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Setup view
    
    func configureView() {
        
        let standingView = StandingView(frame: self.view.frame, viewController: self)

        standingView.collectionView.register(DriverCell.self, forCellWithReuseIdentifier: standingView.cellDriverId)
        standingView.collectionView.register(TeamCell.self, forCellWithReuseIdentifier: standingView.cellTeamId)
        
        standingView.segmentControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeStanding))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeStanding))
        swipeLeft.direction = .left
        
        standingView.collectionView.addGestureRecognizer(swipeRight)
        standingView.collectionView.addGestureRecognizer(swipeLeft)
        standingView.collectionView.delegate = self
        standingView.collectionView.dataSource = self
        
        
        self.standingView = standingView
        self.view.addSubview(standingView)
        
    }
    
//MARK: Actions
    
    @objc func segmentAction(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0  {
            
            standingView.collectionView.reloadData()
            standingView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }else if sender.selectedSegmentIndex == 1  {

            standingView.collectionView.reloadData()
            standingView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: false)

        }
    }
    
    
    @objc func swipeStanding(sender: UISwipeGestureRecognizer) {
        
        standingView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        
        switch sender.direction {
            
        case .right:
            
            if standingView.segmentControl.selectedSegmentIndex != 0 {
                standingView.segmentControl.selectedSegmentIndex = 0
                standingView.collectionView.reloadData()
            }
            
        case .left:
            
            if standingView.segmentControl.selectedSegmentIndex != 1 {
                standingView.segmentControl.selectedSegmentIndex = 1
                standingView.collectionView.reloadData()
            }
        default: break
        }
    }
    
}


extension StandingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return viewModel?.minimumLineSpacingForSectionAt(selectedSegmentIndex: standingView.segmentControl.selectedSegmentIndex) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return viewModel?.sizeForItemAt(indexPath: indexPath, selectedSegmentIndex: standingView.segmentControl.selectedSegmentIndex) ?? CGSize(width: view.frame.width, height: 44)
    }
}

extension StandingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if standingView.segmentControl.selectedSegmentIndex == 1 {
            
            self.viewModel?.choseCellAt(indexPath: indexPath)
            collectionView.reloadData()
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            }
        }
    }
}

extension StandingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       guard let viewModel = viewModel else { return UICollectionViewCell() }

        let model = viewModel.returnModelFrom(selectedSegmentIndex: standingView.segmentControl.selectedSegmentIndex, itemIndex: indexPath.item)
       
       if model is DriverModel {
           let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: standingView.cellDriverId, for: indexPath) as! DriverCell
           cell.configure(driverModel: model as! DriverModel)
           return cell
       }else {
           let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: standingView.cellTeamId, for: indexPath) as! TeamCell
           let isChosen = viewModel.isCellChosen(indexPath: indexPath)
           cell.configure(teamModel: model as! TeamModel, isChosenTeam: isChosen)
           return cell
       }
   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.numberOfItem(selectedSegmentIndex: standingView.segmentControl.selectedSegmentIndex) ?? 0
    }
}

extension StandingViewController {
    
    //MARK: Supported orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
}

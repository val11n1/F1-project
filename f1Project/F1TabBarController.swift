//
//  F1TabBarController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 23.03.2022.
//

import Foundation
import UIKit


class F1TabBarController: UITabBarController {
    
    var lastSelectedItem: UITabBarItem!
    
    override var shouldAutorotate: Bool {
        
        if UIDevice.current.orientation == .portrait {
            
            return true
        }
            return false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createViewControllers()
    }
    
    private func createViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        let standingVc = StandingCollectionViewController(collectionViewLayout: layout)
        
        standingVc.tabBarItem = UITabBarItem(title: "Standing",image: UIImage(named: "trophy")?.withRenderingMode(.alwaysOriginal),tag: 0)
        let navStanding = UINavigationController(rootViewController: standingVc)
        
        lastSelectedItem = standingVc.tabBarItem
        
        let standartAppearence = UINavigationBarAppearance()
        standartAppearence.configureWithOpaqueBackground()
        standartAppearence.backgroundColor = .black
        
        navStanding.navigationBar.standardAppearance = standartAppearence
        navStanding.navigationBar.scrollEdgeAppearance = standartAppearence
        
        
        let newsController = NewsTableViewController(style: .plain)
        newsController.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "news")?.withRenderingMode(.alwaysOriginal), tag: 0)
        let navForNews = UINavigationController(rootViewController: newsController)
        //navForNews.navigationBar.standardAppearance = standartAppearence
        
        
        let ScheduleController = ScheduleTableViewController()
        ScheduleController.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(named: "car")!.withRenderingMode(.alwaysOriginal), tag: 0)
        let navForHightlights = UINavigationController(rootViewController: ScheduleController)
        navForHightlights.navigationBar.standardAppearance = standartAppearence
        
        self.viewControllers = [navStanding, navForNews, navForHightlights]
        
        let sa = UITabBarAppearance(barAppearance: tabBar.standardAppearance)
        sa.configureWithOpaqueBackground()
        sa.backgroundColor = .black

        tabBar.standardAppearance = sa
        tabBar.isTranslucent = false
        
    }
    
    
}

//MARK: UITabBarDelegate
extension F1TabBarController {
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if lastSelectedItem == item {
            
            let nav = selectedViewController as! UINavigationController
            
            switch nav.visibleViewController {
            case is StandingCollectionViewController:
                
                let vc = nav.visibleViewController as! StandingCollectionViewController
                
                if vc.driversArray != nil && vc.teamsArray != nil {
                    
                    vc.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
                
            case is NewsTableViewController:
                
                let vc = nav.visibleViewController as! NewsTableViewController
                
                if vc.newsArray != nil && vc.pinnedNewsArray != nil {
                    
                    vc.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }

            case is ScheduleTableViewController:
                
                let vc = nav.visibleViewController as! ScheduleTableViewController
                
                if vc.upcomingRaceArray != nil && vc.pastRacesArray != nil {
                    
                    vc.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }


            default:break
            }
            
        }else {
            
            lastSelectedItem = item
        }
    }
}

//
//  TabBarControllerTests.swift
//  f1ProjectTests
//
//  Created by Valeriy Trusov on 26.07.2022.
//

import XCTest
@testable import f1Project

class TabBarControllerTests: XCTestCase {

    var tabBar: F1TabBarController!
    var item: UITabBarItem!
    
    override func setUpWithError() throws {
        
        self.tabBar = F1TabBarController()
        let lastItemNumber = tabBar.tabBar.items!.count - 1
        item = tabBar.tabBar.items![lastItemNumber]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabBarControllerHaveStandingCollectionViewController() {
        
        var standingVC: StandingCollectionViewController?
        var newsVC: NewsTableViewController?
        var scheduleVC: ScheduleTableViewController?
        
        for nav in tabBar.children {
            
            if let nav = nav as? UINavigationController {
                
                let vc = nav.viewControllers.first
                
                if vc is StandingCollectionViewController {
                    
                    standingVC = vc as? StandingCollectionViewController
                }else if vc is NewsTableViewController {
                    
                    newsVC = vc as? NewsTableViewController
                }else if vc is ScheduleTableViewController {
                    
                    scheduleVC = vc as? ScheduleTableViewController
                }
            }
        }
        
        XCTAssertNotNil(standingVC)
        XCTAssertNotNil(newsVC)
        XCTAssertNotNil(scheduleVC)
    }
    
    func testTabBarLastSelectedIndexNotNil() {
        
        
        
        tabBar.tabBar(tabBar.tabBar, didSelect: item!)
        
        XCTAssertNotNil(tabBar.lastSelectedItem)
    }
    
    func testTabBarLastSelectedIndexIsFirstItem() {
        
        
        tabBar.tabBar(tabBar.tabBar, didSelect: item!)
        
        XCTAssertEqual(tabBar.lastSelectedItem, item)
    }
    
    func testDeviceOrientationIsAlwaysPortrait() {
        
        let device = UIDevice.current
        device.setValue(UIDeviceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first as! UIWindowScene
        
        XCTAssertTrue(sceneDelegate.interfaceOrientation == .portrait)
    }
}




//
//  SceneDelegateTests.swift
//  f1ProjectTests
//
//  Created by Valeriy Trusov on 26.07.2022.
//

import XCTest
@testable import f1Project

class SceneDelegateRootControllerTests: XCTestCase {

    override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()  {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsRootViewControllerOfSceneDelegareWindowF1TabBarController() {
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = sceneDelegate.windows.first
        let rootViewController = window?.rootViewController
        
        XCTAssertTrue(rootViewController is F1TabBarController)
    }

}

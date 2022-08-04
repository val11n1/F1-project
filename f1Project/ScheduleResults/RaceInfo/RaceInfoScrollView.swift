//
//  RaceInfoScrollView.swift
//  f1Project
//
//  Created by Valeriy Trusov on 02.08.2022.
//

import Foundation
import UIKit


class RaceInfoScrollView: UIScrollView, UIScrollViewDelegate {
    
    var firstPage: FirstPageViewProtocol!
    var secondPage: SecondPageViewProtocol!
    var thirdPage: ThirdPageViewProtocol!
    
    required init(frame: CGRect, raceInfoModel: RaceModel) {
        super.init(frame: frame)
        setupPages(raceInfoModel: raceInfoModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPages(raceInfoModel: RaceModel) {
        
        self.contentSize = CGSize(width: self.bounds.width * 3, height: self.bounds.size.height)
        self.isPagingEnabled = true
        
        var frame = CGRect(x: self.bounds.origin.x,
                           y: self.bounds.origin.y,
                           width: self.bounds.size.width,
                           height: self.bounds.size.height)
        
        
        self.firstPage = FirstPageView(frame: frame,
                                       raceInfoModel: raceInfoModel)
        
        frame.origin.x += self.bounds.size.width

        self.secondPage = SecondPageView(frame: frame, raceInfoModel: raceInfoModel)
        
        frame.origin.x += self.bounds.size.width
        
        self.thirdPage = ThirdPageView(frame: frame)
        
        self.addSubview(firstPage as! UIView)
        self.addSubview(secondPage as! UIView)
        self.addSubview(thirdPage as! UIView)
    }
}

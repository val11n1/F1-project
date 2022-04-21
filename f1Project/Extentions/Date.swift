//
//  Date.swift
//  f1Project
//
//  Created by Valeriy Trusov on 18.04.2022.
//

import Foundation


extension Date {
    
    func returnCurrentDate() -> Date {
        
        let timeZoneOffset = TimeInterval(TimeZone.current.secondsFromGMT())
        
        return Date().addingTimeInterval(timeZoneOffset)
    }
}

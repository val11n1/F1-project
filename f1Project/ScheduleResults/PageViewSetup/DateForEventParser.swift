//
//  DateForEventParser.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit


struct DateForEventParser {
    
    static func dateAndTimeForEvent(date: String, time: String, viewForText: UILabel) {
        
        let dateFormatter = DateFormatter()
        //let calendar = Calendar.current
        
        let timeZoneOfset = TimeInterval(TimeZone.current.secondsFromGMT())
        
        dateFormatter.dateFormat = "HH:mm"
        let eventTime = dateFormatter.date(from: time)!.addingTimeInterval(timeZoneOfset)
        let eventTimeString = dateFormatter.string(from: eventTime)
        
        dateFormatter.dateFormat = "yyyy-MM-dd/"
        let eventDate = dateFormatter.date(from: date)!.addingTimeInterval(timeZoneOfset)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let eventDateString = dateFormatter.string(from: eventDate)

        viewForText.text = "Date: \(eventDateString), time: \(eventTimeString)"
    }
}

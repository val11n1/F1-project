//
//  networkingManager.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import Foundation
import SwiftSoup


class networkingManager {
    
    static let shared = networkingManager()
    
    enum ResponceType {
        
        case DriverResponce
        case TeamResponce
        case RaceScheduleResponce
        case RaceResultResponce
    }
   
    
     
    func fetchData(type: networkingManager.ResponceType,round: Int?, completionHandler: @escaping ([ModelProtocol]?) -> Void) {
        
        var urlString = String()
        
        switch type {
            
        case .DriverResponce:
            urlString = "http://ergast.com/api/f1/current/driverStandings.JSON"
        case .TeamResponce:
            urlString = "http://ergast.com/api/f1/current/constructorStandings.JSON"
        case .RaceScheduleResponce:
            urlString = "http://ergast.com/api/f1/current.JSON"
        case .RaceResultResponce:
            
            let date = Date()
            let calendar = Calendar.current
            let component = calendar.component(.year, from: date)
            
             urlString = "http://ergast.com/api/f1/\(component)/\(round!)/results.json"
        }
        
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [unowned self] data, responce, error in
            
            if let data = data {
                

                let array = JSONParcing(type: type, data: data)
                completionHandler(array.count == 0 ? nil: array)
            }
        }
        task.resume()
    }
    
    func fetchNews() -> [[Element]]? {
        
        var pinnedNewsArr = [Element]()
        var newsArr = [Element]()
        let urlString = "https://www.f1news.ru"
        var firstSevenNews = 0
        guard let url = URL(string: urlString) else { return nil }

        do {
            
            if let myHtmlString = try? String(contentsOf: url, encoding: .utf8) {
            do {

                let doc = try! SwiftSoup.parse(myHtmlString)
                let linkes: Elements = try! doc.select("a")
                
                
                for el in linkes {
                    
                    let text = try el.text()
                    
                        if text.count >= 19 {
                            
                            if firstSevenNews < 7 {
                                pinnedNewsArr.append(el)
                                firstSevenNews += 1
                            }else {
                                
                                newsArr.append(el)
                                
                            }
                        }
                }
            }
            }
            
        }catch let err {

            print(err.localizedDescription)
        }
        return [pinnedNewsArr,newsArr]
    }
    
  
    private func JSONParcing(type: networkingManager.ResponceType, data: Data) -> [ModelProtocol] {
        
        var resultArray = [ModelProtocol]()
        
        switch type {
        
        case .DriverResponce:
            resultArray = DriverModel.createDriverModelArray(data: data)
        case .TeamResponce:
            resultArray = TeamModel.createTeamModelArray(data: data)
        case .RaceScheduleResponce:
            resultArray = RaceModel.createRaceModelArray(data: data)
        case .RaceResultResponce:
            resultArray = RaceResult.createRaceResultArray(data: data)
        }
        return resultArray
}
}

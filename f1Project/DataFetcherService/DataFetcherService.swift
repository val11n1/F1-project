//
//  DataFetcherService.swift
//  f1Project
//
//  Created by Valeriy Trusov on 02.08.2022.
//

import Foundation
import SwiftSoup


class DataFetcherService {
    
    private var dataFetcher: DataFetcherProtocol!
    
    init(dataFetcher: DataFetcherProtocol = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func fetchDriversStanding(completion: @escaping (DriverStandings?) -> ()) {
        let urlString = "http://ergast.com/api/f1/current/driverStandings.JSON"
        dataFetcher.fetchGenericJSONData(urlString: urlString, responce: completion)
    }
    
    func fetchTeamsStanding(completion: @escaping (TeamStandings?) -> ()) {
        let urlString = "http://ergast.com/api/f1/current/constructorStandings.JSON"
        dataFetcher.fetchGenericJSONData(urlString: urlString, responce: completion)

    }
    
    func fetchRaces(completion: @escaping (RacesSchedule?) -> ()) {
        let urlString = "http://ergast.com/api/f1/current.JSON"
        dataFetcher.fetchGenericJSONData(urlString: urlString, responce: completion)

    }
    
    func fetchDriversRaceResult(from date: Date, round: Int, completion: @escaping (RaceResultModel?) -> ()) {
        
        let calendar = Calendar.current
        let component = calendar.component(.year, from: date)
        let urlString = "http://ergast.com/api/f1/\(component)/\(round)/results.JSON"
        dataFetcher.fetchGenericJSONData(urlString: urlString, responce: completion)

    }
    
    func fetchNews(completion: @escaping ([[Element]]?) -> ()) {
        
        var pinnedNewsArr = [Element]()
        var newsArr = [Element]()
        let urlString = "https://www.f1news.ru"
        var firstSevenNews = 0
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

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
            completion(nil)
        }
        completion([pinnedNewsArr,newsArr])
    }
}

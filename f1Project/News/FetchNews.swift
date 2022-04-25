//
//  FetchNews.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import SwiftSoup

class FetchNews {
    
    static func fetchNews() -> ([Element]?, [Element]?) {
        
        var pinnedNewsArr = [Element]()
        var newsArr = [Element]()
        let urlString = "https://www.f1news.ru"
        var firstSevenNews = 0
        guard let url = URL(string: urlString) else { return (pinnedNewsArr, newsArr) }

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
        
        return (pinnedNewsArr, newsArr)
    }
}

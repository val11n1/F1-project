//
//  HighlightsController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 31.03.2022.
//

import Foundation
import UIKit
import SwiftSoup

class HighlightsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchHighlights()
    }
    
    private func fetchHighlights() {
        
        let urlString = "https://www.f1news.ru/news/f1-158935.html"
        guard let url = URL(string: urlString) else { return }

        do {
            
            let myHtmlString = try! String(contentsOf: url, encoding: .utf8)
            do {

                let doc = try! SwiftSoup.parse(myHtmlString)
                print(doc)
                let linkes: Elements = try! doc.select("tr")
                
                for el in linkes {
                    //print(el)
                    do {
                        
                        let text = try el.text()
                        print(text)
                        
                    }catch _ {
                        
                        
                    }
                    
                }
            }
        }
    }
}

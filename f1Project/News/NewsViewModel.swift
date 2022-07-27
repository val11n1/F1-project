//
//  NewsViewModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 27.07.2022.
//

import Foundation
import UIKit
import SwiftSoup


class NewsViewModel: NewsViewModelProtocol {
    
    
    var newsArray: [[Element]]?
    
    private init(array: [[Element]]) {
        self.newsArray = array
    }
    
    init() {
        
    }
    
    static func createViewModel(completion: (NewsViewModelProtocol) -> ()) {
        
        if let resultArray = networkingManager.shared.fetchNews() {
            
            let viewModel = NewsViewModel(array: resultArray)
            completion(viewModel)
        }else {
            completion(NewsViewModel())
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        
        if let newsArray = newsArray {
            return newsArray[section].count
        }else {
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        if let newsArray = newsArray {
            return newsArray.count
        }else {
            return 0
        }
    }
    
    func elementFrom(indexPath: IndexPath) -> Element? {
        
        if let newsArray = newsArray {
            return newsArray[indexPath.section][indexPath.row]
        }
        return nil
    }
    
    func heightForRow() -> CGFloat {
        return 100.0
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        
        switch section {
            
        case 0: return "Pinned"
        case 1: return "News"
        default: return nil
        }
    }
    
    private func linkFrom(indexPath: IndexPath) -> String? {
        
        if let element = elementFrom(indexPath: indexPath) {
        
        do {
            var link: String = try element.attr("href")
            
            if link.hasPrefix("http") {
                
                let stringIndex = link.index(link.startIndex, offsetBy: 4)
                link.insert("s", at: stringIndex)
                return link
                
            }else {
                
                return "https://www.f1news.ru" + link
                
            }
        }catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
        return nil
    }
    
    func createWebControllerFrom(indexPath: IndexPath) -> WebNewsController? {
        
        if let link = linkFrom(indexPath: indexPath) {
            
            let webController = WebNewsController()
            webController.urlString = link
            return webController
        }
        return nil
    }
}

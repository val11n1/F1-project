//
//  NewsTableViewController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 29.03.2022.
//

import Foundation
import UIKit
import SwiftSoup

class NewsTableViewController: UITableViewController {
    
    let newsCellId = "newsCellId"
    let newsHeaderFooterId = "newsHeaderFooterId"
    var pinnedNewsArray: [Element]?
    var newsArray: [Element]?
    let activityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        activityIndicator.startAnimating()
        tableView.separatorStyle = .none
        navigationItem.title = "News"
        
        let queue = DispatchQueue(label: "NewsQueue", qos: .utility, attributes: .concurrent)
        
        queue.async { [unowned self] in
            
            let tupleArray = fetchNews()
            
            if let pinnedArray = tupleArray.0, let newNewsArray = tupleArray.1 {
            
                pinnedNewsArray = pinnedArray
                newsArray = newNewsArray
                
            DispatchQueue.main.sync {
                activityIndicator.stopAnimating()
                tableView.reloadData()
            }
            }else {
                
                
            }
        }
        
        tableView.register(NewsCell.self, forCellReuseIdentifier: newsCellId)
        tableView.register(BaseHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: newsHeaderFooterId)
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return pinnedNewsArray == nil ? 0: pinnedNewsArray!.count
        }else {
            return newsArray == nil ? 0: 30
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellId) as! NewsCell
        
        
        let element = indexPath.section == 0 ? pinnedNewsArray![indexPath.row]: newsArray![indexPath.row]
        
        cell.configure(element: element)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: newsHeaderFooterId) as! BaseHeaderFooterView
        
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Pinned news": "News"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let element = indexPath.section == 0 ? pinnedNewsArray![indexPath.row]: newsArray![indexPath.row]
        
        do {
            var link: String = try element.attr("href")
            
            if link.hasPrefix("http") {
                
                let stringIndex = link.index(link.startIndex, offsetBy: 4)
                link.insert("s", at: stringIndex)
                createWebNewsController(link: link)
                
            }else {
                
                createWebNewsController(link: "https://www.f1news.ru" + link)
                
            }
        }catch let err {
            print(err.localizedDescription)
        }
    }
    
    
    //MARK: Fetch news
    
    private func fetchNews() -> ([Element]?, [Element]?) {
        
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

            }else {
                
                return (nil, nil)
            }
            
            
        }catch let err {

            print(err.localizedDescription)
        }
        
        return (pinnedNewsArr, newsArr)
    }
    
    //MARK: WebViewController setup
    
    private func createWebNewsController(link: String) {
        
        let webController = WebNewsController()

        webController.urlString = link
        navigationController?.present(webController, animated: true)
    }
    
    //MARK: SetupViews
    
    private func setupView() {
        
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
        
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -25),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}

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
    var viewModel: NewsViewModelProtocol?
    
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
        tableView.register(NewsCell.self, forCellReuseIdentifier: newsCellId)
        tableView.register(BaseHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: newsHeaderFooterId)
        
        NewsViewModel.createViewModel { [weak self] viewModel in
            
            self?.activityIndicator.stopAnimating()

            if let viewModel = viewModel {
                self?.viewModel = viewModel
                self?.tableView.reloadData()
            }
        }
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

extension NewsTableViewController {
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel?.numberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: newsCellId) as! NewsCell
        
        if let element = viewModel?.elementFrom(indexPath: indexPath) {
            cell.configure(element: element)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: newsHeaderFooterId) as! BaseHeaderFooterView
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRow() ?? 44.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeaderInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let webController = viewModel?.createWebControllerFrom(indexPath: indexPath) {
            
            navigationController?.present(webController, animated: true)
        }
    }
}

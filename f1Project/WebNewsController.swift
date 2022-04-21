//
//  WebNewsController.swift
//  f1Project
//
//  Created by Valeriy Trusov on 30.03.2022.
//

import Foundation
import UIKit
import WebKit


class WebNewsController: UIViewController {
    
    var urlString: String!
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadWebViewContent()
        
    }
    
    private func loadWebViewContent() {
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        
    }
    
    private func setupViews() {
        
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let gobackButton = UIButton()
        
        gobackButton.setTitle("Back", for: .normal)
        gobackButton.setTitleColor(toolBar.barTintColor, for: .normal)
        gobackButton.titleLabel?.textAlignment = .center
        gobackButton.titleLabel?.textColor = .white
        gobackButton.translatesAutoresizingMaskIntoConstraints = false
        gobackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(toolBar)
        toolBar.addSubview(gobackButton)
        NSLayoutConstraint.activate([

            toolBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50),
            
            gobackButton.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor, constant: -5),
            gobackButton.widthAnchor.constraint(equalToConstant: 50),
            gobackButton.topAnchor.constraint(equalTo: toolBar.topAnchor, constant: 3),
            gobackButton.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor, constant: -3)
        ])
        
        
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(webView)
        NSLayoutConstraint.activate([

            webView.topAnchor.constraint(equalTo: toolBar.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        
    }
    
    @objc private func goBackButtonTapped() {
        
       
        self.dismiss(animated: true)
        webView.stopLoading()

    }
    
    deinit {
        
        webView.stopLoading()
    }
}

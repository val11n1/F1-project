//
//  NewsViewModelProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 27.07.2022.
//

import Foundation
import SwiftSoup


protocol NewsViewModelProtocol {
    
    static func createViewModel(completion: @escaping (NewsViewModelProtocol) -> ()) 
    func numberOfRowsInSection(section: Int) -> Int
    func numberOfSections() -> Int
    func elementFrom(indexPath: IndexPath) -> Element?
    func heightForRow() -> CGFloat
    func titleForHeaderInSection(section: Int) -> String?
    func createWebControllerFrom(indexPath: IndexPath) -> WebNewsController? 
}

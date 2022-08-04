//
//  NetworkingProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 02.08.2022.
//

import Foundation

protocol NetworkingProtocol {
    
    func request(urlString: String, completion: @escaping (Data?, Error?) -> ())
}

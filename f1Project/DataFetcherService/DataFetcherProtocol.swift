//
//  DataFetcherProtocol.swift
//  f1Project
//
//  Created by Valeriy Trusov on 02.08.2022.
//

import Foundation


protocol DataFetcherProtocol {
    func fetchGenericJSONData<T: Decodable>(urlString: String, responce: @escaping (T?) -> ())
}

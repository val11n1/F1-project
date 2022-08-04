//
//  NetworkDataFetcher.swift
//  f1Project
//
//  Created by Valeriy Trusov on 02.08.2022.
//

import Foundation


class NetworkDataFetcher: DataFetcherProtocol {
    
    var networking: NetworkingProtocol
    
    init(networking: NetworkService = NetworkService()) {
        self.networking = networking
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, responce: @escaping (T?) -> ()) {
        
        networking.request(urlString: urlString) { data, error in
            
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                responce(nil)
            }
            
            let decoded = self.decodeJSON(type: T.self, from: data)
            responce(decoded)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            
            let objects = try decoder.decode(type, from: data)
            return objects
            
        } catch let error {
            
            print("Failed to decode JSON", error.localizedDescription)
            return nil
        }
    }
}

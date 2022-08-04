//
//  NetworkService.swift
//  f1Project
//
//  Created by Valeriy Trusov on 22.03.2022.
//

import Foundation


class NetworkService: NetworkingProtocol {
    
    func request(urlString: String, completion: @escaping (Data?, Error?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping ( Data?, Error?) -> ()) -> URLSessionDataTask {
        
        return URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

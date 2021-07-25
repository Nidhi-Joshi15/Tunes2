//
//  ServiceManager.swift
//  TunesDemo
//
//  Created by Nidhi Joshi on 27/04/2021.
//

import Foundation
import Network

class ServiceManager {
    func fetchData(url: String, onSuccess: @escaping (Result?) -> Void, onError: @escaping (String) -> Void) {
        dataTask?.cancel()
        if  !Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                onError("Internet connection error")
            }
        }
        guard var request = apiRequest else {
            return
        }
        request.url = URL(string: url)
        print(url)
        dataTask = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                onError("Request failed")
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Result.self, from: data)
                DispatchQueue.main.async {
                    onSuccess(result)
                }
            } catch let error {
                DispatchQueue.main.async {
                    onError("Decode error: \(error)")
                    return
                }
            }
        }
        
        dataTask?.resume()
       
    }
    
    // MARK: - Private
    
    private var dataTask: URLSessionDataTask?
    private let apiBaseUrl = Constant.url
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        
        return URLSession(configuration: configuration)
    }
    private var apiUrl: URL? {
        return URL(string: apiBaseUrl)
    }
    
    private var apiRequest: URLRequest? {
        guard let apiURL = apiUrl  else {
            return nil
        }
        var request = URLRequest(url: apiURL)
        request.cachePolicy = .reloadRevalidatingCacheData
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        return request
    }
    
}

//
//  CoinAPI.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 22/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

final class CoinAPI: NSObject {
    
    lazy var url: String = {
        guard let url = Config().getUrlStandard() else { return "" }
        return url
    }()
    
    func fetchCoinRequest(completion: @escaping(Bool ,Dictionary<String, Any>) -> Void) {
        guard let url = URL(string: url) else {
            completion(false, Dictionary<String, Any>())
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Network error: \(error)")
                completion(false, Dictionary<String, Any>())
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                completion(false, Dictionary<String, Any>())
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false, Dictionary<String, Any>())
                return
            }
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                    completion(true, jsonDictionary)
                } else {
                    print("Invalid JSON format")
                    completion(false, Dictionary<String, Any>())
                }
            } catch {
                print("JSON serialization error: \(error)")
                completion(false, Dictionary<String, Any>())
            }
        }
        
        task.resume()
    }
}

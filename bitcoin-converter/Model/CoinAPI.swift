//
//  CoinAPI.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 22/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import Alamofire

final class CoinAPI: NSObject {
    
    lazy var url: String = {
        guard let url = Config().getUrlStandard() else { return "" }
        return url
    }()
    
    func fetchCoinRequest(completion: @escaping(Bool ,Dictionary<String, Any>) -> Void) {
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let responseDictionary = response.value as? Dictionary<String, Any> {
                    completion(true , responseDictionary)
                }
            case .failure:
                completion(false, Dictionary<String, Any>())
            }
        }
    }
    
//    func fetchCoinRequest(completion: @escaping(Bool, Data) -> Void) {
//            AF.request(url).responseData { (response) in
//                switch response.result {
//                case .success:
//                    if let responseData = response.data {
//                        completion(true, responseData)
//                    }
////                    break
//                case .failure:
//                    completion(false, Data())
////                    break
//                }
//            }
//
//        }
}

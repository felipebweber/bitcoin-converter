//
//  CoinManager.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate: class {
    func didUpdatePrice(price: String, currency: String)
}

class CoinManager {
    
    weak var delegate: CoinManagerDelegate?
    
    let baseString = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let api = "84FBBDB5-F410-4E60-A6F9-374DEDE43216#"
    
    let currentArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "USD"]
    
    func fetchCoinPrice(for currency: String) {
        let urlString = "\(baseString)/\(currency)?apikey=\(api)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, _, _) in
                guard let data = data else { return }
                guard let self = self else { return }
                guard let bitcoinPrice = self.parseJSON(data) else { return }
                let priceString = String(format: "%.2f", bitcoinPrice)
                self.delegate?.didUpdatePrice(price: priceString, currency: currency)
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        let decodeData = try? decoder.decode(CoinData.self, from: data)
        guard let lastPrice = decodeData?.rate else { return nil }
        return lastPrice
    }
}

//
//  CoinManager.swift
//  BTConverter
//

import Foundation
import  UIKit
import CoreData

protocol CoinManagerDelegate: class {
    func didUpdateFail()
    func didUpdateData()
}

final class CoinManager {
    
    weak var delegate: CoinManagerDelegate?
    private var coinApi = CoinAPI()
    //    private var manageResult: NSFetchedResultsController<CoinEntity>?
    private let  userDefaultsManager = UserDefaultsManager()
    private let saveRetrieveData = SaveRetrieveData()
    
    //Acesso ao contexto
    //    private var context: NSManagedObjectContext {
    //        return DatabaseManager.shared.persistentContainer.viewContext
    //    }
    
    let currentArray = ["USD", "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "DKK", "EUR", "GBP", "HKD", "INR", "ISK", "JPY", "KRW", "NZD", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD"]
}

extension CoinManager {
    
    func fetchCoinPrice() {
        
        coinApi.fetchCoinRequest { (result, dictionary) in
            if result {
                DispatchQueue.main.async {
                    let date = Date().formattedHour()
                    print("Date: \(date)")
                    self.userDefaultsManager.setHourUpdate(date: date)
                    let coinList = self.parseJSON(dictionary)
                    self.saveRetrieveData.saveAll(coinList)
                    self.delegate?.didUpdateData()
                }
            } else {
                print("Erro de conexão")
                self.delegate?.didUpdateFail()
            }
            
        }
        
    }
    
    //    private func parseJSON(_ coinData: Data) ->[CoinModel] {
    //
    //        var coinList = [CoinModel]()
    //
    //        let decoder = JSONDecoder()
    //        guard let decodeData = try? decoder.decode(CoinDataResponse.self, from: coinData) else { return [] }
    //
    //        for (key, value) in decodeData.market_data.current_price {
    //            coinList.append(CoinModel(symbol: "opa", value: value, currency: key))
    //        }
    //
    //        return coinList
    //    }
    
    internal func parseJSON(_ dictionary: Dictionary<String, Any>) -> [CoinModel] {
        var coinList = [CoinModel]()
        
        for (key, value) in dictionary {
            guard let val = value as? Dictionary<String, Any> else { return [] }
            guard let value = val["last"] as? Double else { return [] }
            guard let symbol = val["symbol"] as? String else { return [] }
            coinList.append(CoinModel(symbol: symbol, value: value, currency: key))
        }
        return coinList
    }
}

extension Date {
    func formattedHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}

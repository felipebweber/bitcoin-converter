//
//  CoinManager.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
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
    private var manageResult: NSFetchedResultsController<CoinEntity>?
    private let  selectedCurrencyUserDefaults = SelectedCurrencyUserDefaults()
    
    //Acesso ao contexto
    private var context: NSManagedObjectContext {
        return DatabaseManager.shared.persistentContainer.viewContext
    }
    
    let currentArray = ["USD", "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "DKK", "EUR", "GBP", "HKD", "INR", "ISK", "JPY", "KRW", "NZD", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD"]
}

extension CoinManager {
    
    func fetchCoinPrice() {
        
        coinApi.fetchCoinRequest { (result, dictionary) in
            if result {
                DispatchQueue.main.async {
                    let date = Date().formattedHour()
                    print("Date: \(date)")
                    self.selectedCurrencyUserDefaults.setHourUpdate(date: date)
                    let coinList = self.parseJSON(dictionary)
                    self.saveAll(coinList)
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
    
    private func saveAll(_ coinList: [CoinModel]) {
        for coin in coinList {
            save(currency: coin.currency, price: coin.value, symbol: coin.symbol)
        }
    }
    
    private func save(currency: String, price: Double, symbol: String) {
        
        var coinEntity: NSManagedObject?
        
        let coinEntitys = retrieve().filter() {
            $0.currency == currency
        }
        
        if coinEntitys.count > 0 {
            guard let coinEntityFind = coinEntitys.first else { return }
            coinEntity = coinEntityFind
        } else {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "CoinEntity", in: context) else { return }
            coinEntity = NSManagedObject(entity: entityDescription, insertInto: context)
        }
        
        coinEntity?.setValue(currency, forKey: "currency")
        coinEntity?.setValue(price, forKey: "price")
        coinEntity?.setValue(symbol, forKey: "symbol")
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar")
        }
    }
    
    func retrieveData(currency: String) -> CoinEntity? {
        
        for result in retrieve() {
            guard let currencyResult = result.currency else { return result }
            
            if currencyResult == currency {
                return result
            }
        }
        return nil
    }
    
    private func retrieve() -> [CoinEntity] {
        
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        let sortCurrency = NSSortDescriptor(key: "currency", ascending: true)
        fetchRequest.sortDescriptors = [sortCurrency]
        
        manageResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try manageResult?.performFetch()
            
        } catch {
            print(error.localizedDescription)
        }
        
        guard let result = manageResult?.fetchedObjects else { return []}
        return result
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

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
        
        coinApi.fetchCoinRequest { (result ,dictionay) in
            if result {
                DispatchQueue.main.async {
                    let date = self.getHour(Date())
                    print("Date: \(date)")
                    self.selectedCurrencyUserDefaults.setHourUpdate(date: date)
                    self.parseJSON(dictionay)
                }
            } else {
                print("Erro de conexão")
                self.delegate?.didUpdateFail()
            }
            
        }
        
    }
    
    private func parseJSON(_ dictionary: Dictionary<String, Any>) {
        
        for (key, value) in dictionary {
            guard let val = value as? Dictionary<String, Any> else { return }
            guard let value = val["last"] as? Double else { return }
            guard let symbol = val["symbol"] as? String else { return }
            save(currency: key, price: value, symbol: symbol)
        }
    }
    
    private func getHour(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
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
//                let priceString = toCurrencyFormat(price: result.price)
//                let symbol = result.symbol
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
    
    private func toCurrencyFormat(price: Double) -> String {
        
        let currencyFormat = NumberFormatter()
        currencyFormat.usesGroupingSeparator = true
        currencyFormat.numberStyle = NumberFormatter.Style.decimal
        currencyFormat.locale = Locale.current
        guard let priceString = currencyFormat.string(from: NSNumber(value: price)) else { return ""}
        return priceString
    }
}

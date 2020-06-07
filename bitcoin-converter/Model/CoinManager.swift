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
    func didUpdatePrice(price: String, currency: String)
}

class CoinManager {
    
    weak var delegate: CoinManagerDelegate?
    
    var coinApiTeste = CoinAPI()
    
    var manageResult: NSFetchedResultsController<CoinEntity>?
    
    //Acesso ao contexto
    var context: NSManagedObjectContext {
        return DatabaseManager.shared.persistentContainer.viewContext
    }
    
    let currentArray = ["USD", "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "DKK", "EUR", "GBP", "HKD", "INR", "ISK", "JPY", "KRW", "NZD", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD"]
    
    
    func fetchCoinPrice() {
        
        coinApiTeste.fetchCoinRequest { (dictionay) in
            DispatchQueue.main.async {
                self.parseJSON(dictionay)
//                self.retrieveData(currency: "USD")
            }
        }
        
    }
    
    func parseJSON(_ dictionary: Dictionary<String, Any>) {
        
        for (key, value) in dictionary {
            guard let val = value as? Dictionary<String, Any> else { return }
            guard let valueSafe = val["last"] as? Double else { return }
            save(currency: key, price: valueSafe)
        }
    }
}

extension CoinManager {
    
    func save(currency: String, price: Double) {
        
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
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar")
        }
    }
    
    func retrieveData(currency: String) -> String {
        
        for result in retrieve() {
            guard let currencyResult = result.currency else { return ""}
            
            if currencyResult == currency {
                let priceString = toCurrencyFormat(price: result.price)
                return priceString
//                self.delegate?.didUpdatePrice(price: priceString, currency: currencyResult)
            }
        }
        return ""
    }
    
    func retrieve() -> [CoinEntity] {
        
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
    
    func toCurrencyFormat(price: Double) -> String {
        
        let currencyFormat = NumberFormatter()
        currencyFormat.usesGroupingSeparator = true
        currencyFormat.numberStyle = NumberFormatter.Style.decimal
        currencyFormat.locale = Locale.current
        guard let priceString = currencyFormat.string(from: NSNumber(value: price)) else { return ""}
        return priceString
    }
}

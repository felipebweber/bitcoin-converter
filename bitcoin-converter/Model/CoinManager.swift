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

class CoinManager {
    
    weak var delegate: CoinManagerDelegate?
    var coinApi = CoinAPI()
    var manageResult: NSFetchedResultsController<CoinEntity>?
    private let  selectedCurrencyUserDefaults = SelectedCurrencyUserDefaults()
    
    //Acesso ao contexto
    var context: NSManagedObjectContext {
        return DatabaseManager.shared.persistentContainer.viewContext
    }
    
    let currentArray = ["USD", "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "DKK", "EUR", "GBP", "HKD", "INR", "ISK", "JPY", "KRW", "NZD", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD"]
    
    
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
    
    func parseJSON(_ dictionary: Dictionary<String, Any>) {
        
        for (key, value) in dictionary {
            guard let val = value as? Dictionary<String, Any> else { return }
            guard let valueSafe = val["last"] as? Double else { return }
            save(currency: key, price: valueSafe)
        }
    }
    
    func getHour(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
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

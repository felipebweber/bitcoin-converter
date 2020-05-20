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
    
    var manageResult: NSFetchedResultsController<CoinEntity>?
    
    //Acesso ao contexto
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    let baseString = "https://blockchain.info/ticker"
    
    let currentArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "USD"]
    
    func fetchCoinPrice(for currency: String) {
        let urlString = "\(baseString)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        guard (self?.parseJSON(data)) != nil else { return }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) {
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        guard let dictionary = json as? [String: AnyObject] else { return }
//        print(dictionary)
        for (key, value) in dictionary {
            guard let val = value["last"] as? Double else { return }
            print("Currency: \(key) value: \(val)")
            save(currency: key, price: val)
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
            print("Dados salvos ")
        } catch {
            print("Erro ao salvar")
        }
    }
    
    func retreiveData(currency: String) {
        print("Recebe: \(currency)")
        let fetchRequest: NSFetchRequest<CoinEntity> = CoinEntity.fetchRequest()
        let sortCurrency = NSSortDescriptor(key: "currency", ascending: true)
        fetchRequest.sortDescriptors = [sortCurrency]
        
         manageResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            let results = try context.fetch(fetchRequest)
            print("Tamanho: \(results.count)")
            for result in results {
                guard let currencyResult = result.currency else { return }
                
                if currencyResult == currency {
                    print(currencyResult)
                    self.delegate?.didUpdatePrice(price: "\(result.price)", currency: currencyResult)
                }
            }

        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func retrieve() -> [CoinEntity]{
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

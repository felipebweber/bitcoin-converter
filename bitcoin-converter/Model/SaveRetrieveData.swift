//
//  SaveRetrieveData.swift
//  bitcoin-converter
//

import Foundation
import CoreData

class SaveRetrieveData {
    private var manageResult: NSFetchedResultsController<CoinEntity>?
    
    //Acesso ao contexto
    private var context: NSManagedObjectContext {
        return DatabaseManager.shared.persistentContainer.viewContext
    }
    
    func saveAll(_ coinList: [CoinModel]) {
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

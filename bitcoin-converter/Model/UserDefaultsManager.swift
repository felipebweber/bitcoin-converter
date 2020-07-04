//
//  CurrencyUserDefaults.swift
//  bitcoin-converter
//


import UIKit

final class UserDefaultsManager {
    
    private let keySetHourUpdate = "setHourUpdate"
    private let keyCurrencySelected = "currencySelected"
    
    func save(_ arrayCurrecy: [String]) {
        UserDefaults.standard.set(arrayCurrecy, forKey: keyCurrencySelected)
    }
    
    func retrive() -> [String] {
        guard let data = UserDefaults.standard.object(forKey: keyCurrencySelected) as? [String] else { return [] }
        return data
    }
    
    func updateData(currency: String) {
        let data = retrive()
        let filter = data.filter { (currencyFilter) -> Bool in
            if currency == currencyFilter {
                return false
            }
            return true
        }
        save(filter)
    }
    
    func setHourUpdate(date: String) {
        UserDefaults.standard.set(date, forKey: keySetHourUpdate)
    }
    
    func retriveHourUpdate() -> String {
        guard let hourUpdate = UserDefaults.standard.object(forKey: keySetHourUpdate) as? String else { return "" }
        return hourUpdate
    }
}

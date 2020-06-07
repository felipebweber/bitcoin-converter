//
//  CurrencyUserDefaults.swift
//  bitcoin-converter
//


import UIKit

class SelectedCurrencyUserDefaults {
    
    func save(_ arrayCurrecy: [String]) {
        UserDefaults.standard.set(arrayCurrecy, forKey: "currencySelected")
    }
    
    func retrive() -> [String] {
        guard let data = UserDefaults.standard.object(forKey: "currencySelected") as? [String] else { return [] }
        return data
    }
}

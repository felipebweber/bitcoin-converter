//
//  CurrencyUserDefaults.swift
//  bitcoin-converter
//


import UIKit

final class SelectedCurrencyUserDefaults {
    
    private let keySetHourUpdate = "setHourUpdate"
    
    func save(_ arrayCurrecy: [String]) {
        UserDefaults.standard.set(arrayCurrecy, forKey: "currencySelected")
    }
    
    func retrive() -> [String] {
        guard let data = UserDefaults.standard.object(forKey: "currencySelected") as? [String] else { return [] }
        return data
    }
    
    func setHourUpdate(date: String) {
        UserDefaults.standard.set(date, forKey: keySetHourUpdate)
    }
    
    func retriveHourUpdate() -> String {
        guard let hourUpdate = UserDefaults.standard.object(forKey: keySetHourUpdate) as? String else { return "" }
        return hourUpdate
    }
}

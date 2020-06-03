//
//  CurrencyUserDefaults.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 02/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
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

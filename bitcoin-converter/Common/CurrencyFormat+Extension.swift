//
//  CurrencyFormat.swift
//  bitcoin-converter
//

import Foundation
import UIKit

extension Double {
    func toCurrencyFormat() -> String {
        let currencyFormat = NumberFormatter()
        currencyFormat.usesGroupingSeparator = true
        currencyFormat.numberStyle = NumberFormatter.Style.decimal
        currencyFormat.locale = Locale.current
        currencyFormat.minimumFractionDigits = 2
        guard let priceString = currencyFormat.string(from: NSNumber(value: self)) else { return ""}
        return priceString
    }
}

//
//  WidgetTableViewCell.swift
//  bitcoin-converter-today-extension
//

import UIKit

class WidgetTableViewCell: UITableViewCell {

    static let reuseIdentifier = "todayCell"
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    private let saveRetrieveData = SaveRetrieveData()
    
    func data(currency: String) {
        let result = saveRetrieveData.retrieveData(currency: currency)
        guard let price = result?.price else { return }
        guard let symbol = result?.symbol else { return }
        let priceFormat = Double(price).toCurrencyFormat()
        setCurrencyLabel(currency, "\(symbol) \(priceFormat)")
    }
    
    func setCurrencyLabel(_ currency: String, _ price: String) {
        currencyLabel.text = currency
        priceLabel.text = price
        symbolImageView.image = UIImage(imageLiteralResourceName: currency.lowercased())
    }
}

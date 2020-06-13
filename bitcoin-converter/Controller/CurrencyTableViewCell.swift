//
//  CurrencyTableViewCell.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 02/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

final class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet weak var symbolImageView: UIImageView!
    
    func setCurrencyLabel(_ currency: String,_ price: String) {
        currencyLabel.text = currency
        priceLabel.text = price
    }
}

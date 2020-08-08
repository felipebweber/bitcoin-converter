//
//  SelectorTableViewCell.swift
//  bitcoin-converter
//

import UIKit

final class SelectorTableViewCell: UITableViewCell {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func setSelectorLabel(_ currency: String,_ description: String) {
        currencyLabel.text = currency
        descriptionLabel.text = description
    }
}

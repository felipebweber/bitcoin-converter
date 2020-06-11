//
//  SelectorTableViewCell.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 09/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
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

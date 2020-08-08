//
//  WidgetTableViewCell.swift
//  bitcoin-converter-today-extension
//
//  Created by Felipe Weber on 14/07/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {

    static let reuseIdentifier = "todayCell"
    
    @IBOutlet weak var currencyLabel: UILabel!
    
//    override func awakeFromNib() {
//           super.awakeFromNib()
//           currencyLabel.layer.cornerRadius = 10
//           currencyLabel.layer.masksToBounds = true
//       }
}

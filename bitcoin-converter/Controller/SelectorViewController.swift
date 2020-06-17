//
//  ViewController.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import CoreData

final class SelectorViewController: UIViewController {
    
    @IBOutlet weak var currencySelectorTableView: UITableView!
    
    private let coinManager = CoinManager()
    private let selectedCurrencyUserDefaults = SelectedCurrencyUserDefaults()
    private var arraySelectCurrency = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barTitle = NSLocalizedString("currencysetup", comment: "")
        navigationItem.title = barTitle
        
        arraySelectCurrency = selectedCurrencyUserDefaults.retrive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedCurrencyUserDefaults.save(arraySelectCurrency)
    }
    
}

extension SelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinManager.currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! SelectorTableViewCell
        let currency = coinManager.currentArray[indexPath.row]
        
        if arraySelectCurrency.contains(currency) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        let description = NSLocalizedString(currency.lowercased(), comment: "")

        cell.setSelectorLabel(currency, description)
        return cell
    }
}

extension SelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            let lineOfTable = coinManager.currentArray[indexPath.row]
            arraySelectCurrency.append(lineOfTable)
        } else {
            cell.accessoryType = .none
            let item = coinManager.currentArray[indexPath.row]
            let filter = arraySelectCurrency.filter { (currency) -> Bool in
                if item != currency {
                    return true
                }
                return false
            }
            arraySelectCurrency = filter
        }
    }
}



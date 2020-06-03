//
//  ViewController.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import CoreData

class SelectorViewController: UIViewController {
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCurency: UILabel!
    @IBOutlet weak var currencySelectorTableView: UITableView!
    @IBOutlet weak var updateDate: UILabel!
    
    var coinManager = CoinManager()
    var selectedCurrencyUserDefaults = SelectedCurrencyUserDefaults()
    var arraySelectCurrency = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencySelectorTableView.delegate = self
        currencySelectorTableView.dataSource = self
        
        coinManager.fetchCoinPrice()
        updateDate.text = "Atualizado as: \(getHour(Date()))"
        
        arraySelectCurrency = selectedCurrencyUserDefaults.retrive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedCurrencyUserDefaults.save(arraySelectCurrency)
    }
    
    func getHour(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
}

extension SelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinManager.currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        let item = coinManager.currentArray[indexPath.row]
        if arraySelectCurrency.contains(item) {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = coinManager.currentArray[indexPath.row]
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

extension SelectorViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.labelPrice.text = price
            self.labelCurency.text = currency
        }
    }
}

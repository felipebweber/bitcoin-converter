//
//  TableViewController.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 29/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

class CurrencyViewController: UITableViewController {
    
    let coinManager = CoinManager()
    let selectedCurrencyUserDefaults = SelectedCurrencyUserDefaults()
    var arrayCurrency:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrayCurrency = selectedCurrencyUserDefaults.retrive()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayCurrency.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CurrencyTableViewCell
        let currency = arrayCurrency[indexPath.row]
        cell.priceLabel.text = coinManager.retrieveData(currency: currency)
        cell.currencyLabel.text = currency
        return cell
    }

}

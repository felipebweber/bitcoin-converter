//
//  TableViewController.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 29/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import StoreKit

class CurrencyViewController: UITableViewController {
    
    let coinManager = CoinManager()
    let selectedCurrencyUserDefaults = SelectedCurrencyUserDefaults()
    var arrayCurrency:[String] = []
    
    
//    var products = [SKProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.fetchCoinPrice()
        
        let update = selectedCurrencyUserDefaults.retriveHourUpdate()
        
        self.navigationItem.titleView = setTitle(title: "Bitcoin check", subtitle: "Update \(update)")
        coinManager.delegate = self
        
//        IAProducts.store.requestProducts { (status, products) in
//            if status {
//                guard let products = products else { return }
//                print("Name: \(products)")
//                self.products = products
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let update = selectedCurrencyUserDefaults.retriveHourUpdate()
//        self.navigationItem.titleView = setTitle(title: "Bitcoin check", subtitle: "Update \(update)")
        arrayCurrency = selectedCurrencyUserDefaults.retrive()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.reloadData()
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -5, width: 0, height: 0))

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont.systemFont(ofSize: 10)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
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

    @IBAction func buy(_ sender: Any) {
        let menu = UIAlertController(title: "Compra", message: "Esta compra remove o banner", preferredStyle: .alert)
        
        let buy = UIAlertAction(title: "Buy", style: .default, handler: nil)
        menu.addAction(buy)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(cancel)

        self.present(menu, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CurrencyTableViewCell
        let currency = arrayCurrency[indexPath.row]
        cell.priceLabel.text = coinManager.retrieveData(currency: currency)
        cell.currencyLabel.text = currency
        return cell
    }

}

extension CurrencyViewController: CoinManagerDelegate {
    func didUpdateFail() {
        let alertController = UIAlertController(title: "Sem conexão", message: "Por favor verifique sua conexão com a internet", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

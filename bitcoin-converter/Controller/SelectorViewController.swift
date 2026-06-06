//
//  ViewController.swift
//  BTConverter
//

import UIKit
import CoreData

final class SelectorViewController: UIViewController {
    
    @IBOutlet weak var currencySelectorTableView: UITableView!
    
    private let coinManager = CoinManager()
    private let userDefaultsManager = UserDefaultsManager()
    private var arraySelectCurrency = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barTitle = NSLocalizedString("currencysetup", comment: "")
        navigationItem.title = barTitle
        
        arraySelectCurrency = userDefaultsManager.retrive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userDefaultsManager.save(arraySelectCurrency)
    }
    
}

extension SelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinManager.currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! SelectorTableViewCell
        let currency = coinManager.currentArray[indexPath.row]

        let description = NSLocalizedString(currency.lowercased(), comment: "")
        cell.setSelectorLabel(currency, description)
        cell.applySelectionState(isSelectedItem: arraySelectCurrency.contains(currency), animated: false)
        return cell
    }
}

extension SelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectorTableViewCell else { return }
        let lineOfTable = coinManager.currentArray[indexPath.row]

        if cell.accessoryType == .none {
            arraySelectCurrency.append(lineOfTable)
        } else {
            let filter = arraySelectCurrency.filter { (currency) -> Bool in
                if lineOfTable != currency {
                    return true
                }
                return false
            }
            arraySelectCurrency = filter
        }

        cell.applySelectionState(isSelectedItem: arraySelectCurrency.contains(lineOfTable), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

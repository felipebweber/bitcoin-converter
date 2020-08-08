//
//  WidgetViewController.swift
//  bitcoin-converter-today-extension
//

import UIKit
import NotificationCenter

class WidgetViewController: UIViewController, NCWidgetProviding, UITableViewDelegate {
    
    @IBOutlet weak var todayTableView: UITableView!
    private let identifier = "todayCell"
    
    var arrayCurrency = [String]()
    
    let userDefaultsManager = UserDefaultsManager()
    let saveRetrieveData = SaveRetrieveData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        widgetData()
        setTodayExtensionMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        widgetData()
    }
    
    private func configTableView() {
        todayTableView.dataSource = self
        todayTableView.delegate = self
        todayTableView.register(UINib(nibName: "WidgetTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        todayTableView.reloadData()
        todayTableView.tableFooterView = UIView(frame: CGRect.zero)
        todayTableView.rowHeight = 40
    }
    
    private func widgetData() {
        if let arrayCurrency = UserDefaults.init(suiteName: "group.felipeweber.bitcoin-check.widget")?.value(forKey: "keyArrayCurrency") as? [String] {
            self.arrayCurrency = arrayCurrency
        }
    }
    
    private func setTodayExtensionMode() {
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let newHeight: CGSize = CGSize(width: 0, height: (arrayCurrency.count)*40)
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: newHeight.height)
        }
    }
}

extension WidgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WidgetTableViewCell
        let currency = arrayCurrency[indexPath.row]
        cell.data(currency: currency)
        
        return cell
    }
}

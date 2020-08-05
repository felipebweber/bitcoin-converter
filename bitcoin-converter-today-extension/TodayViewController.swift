//
//  TodayViewController.swift
//  bitcoin-converter-today-extension
//
//  Created by Felipe Weber on 10/07/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var todayTableView: UITableView!
    
    
    var array: [String] = []
    
    let userDefaultsManager = UserDefaultsManager()
//    private let coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //todayTableView.delegate = self
        todayTableView.dataSource = self
        // Do any additional setup after loading the view.
//        array = userDefaultsManager.retrive()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
//        let todayTableViewCell = UINib(nibName: "todayCell", bundle: nil)
//        tableView.register(todayTableView, forCellReuseIdentifier: TodayTableViewCell.reuseIdentifier)
//        tableView.register(todayTableView, forCellReuseIdentifier: TodayTableViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        currencyLabel.text = array.first
        if let favorites = UserDefaults.init(suiteName: "group.felipeweber.bitcoin-check.widget")?.value(forKey: "ops") as? [String] {
            let first = favorites.first
           
            currencyLabel.text = first
//            let result = coinManager.retrieveData(currency: first)
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: maxSize.height)
        }
    }
    
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! SelectorTableViewCell
        currencyLabel.text = "OPA"
//        cell.textLabel?.text = "Aee"
        return cell
    }
    
    
}

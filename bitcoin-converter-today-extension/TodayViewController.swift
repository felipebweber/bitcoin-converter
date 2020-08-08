//
//  WidgetViewController.swift
//  bitcoin-converter-today-extension
//
//  Created by Felipe Weber on 10/07/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import NotificationCenter

class WidgetViewController: UIViewController, NCWidgetProviding, UITableViewDelegate {
        
    //@IBOutlet weak var currencyLabel: UILabel!
    //@IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var todayTableView: UITableView!
    private let identifier = "todayCell"
    
    var array: [String] = []
    
    let userDefaultsManager = UserDefaultsManager()
//    private let coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
//        setTodayExtensionMode()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        currencyLabel.text = array.first
        if let favorites = UserDefaults.init(suiteName: "group.felipeweber.bitcoin-check.widget")?.value(forKey: "ops") as? [String] {
            let first = favorites.first
           
            //currencyLabel.text = first
//            let result = coinManager.retrieveData(currency: first)
        }
    }
    
    private func configTableView() {
        todayTableView.dataSource = self
        todayTableView.delegate = self
        todayTableView.register(UINib(nibName: "WidgetTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        todayTableView.reloadData()
    }
    
    private func setTodayExtensionMode() {
           if #available(iOSApplicationExtension 10.0, *) {
               self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
           } else {
               print("iOS8, iOS9需要自己添加折叠按钮..")
           }
       }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
//    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//       
//        // #available 用在条件语句代码块中,判断不同的平台下,做不同的逻辑处理
//        if #available(iOSApplicationExtension 11.0, *) {
//            if extensionContext?.widgetActiveDisplayMode == .compact{
//                completionHandler(NCUpdateResult.newData)
//            }else{
//                completionHandler(NCUpdateResult.noData)
//            }
//        }else {
//            completionHandler(NCUpdateResult.newData)
//        }
//    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: maxSize.height)
        }
    }
    
}

extension WidgetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableViewCell")!
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WidgetTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! SelectorTableViewCell
        cell.currencyLabel.text = "OPA"
//        cell.textLabel?.text = "Aee"
        return cell
    }
    
    
}

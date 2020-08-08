//
//  TableViewController.swift
//  bitcoin-converter
//

import UIKit
import StoreKit
import GoogleMobileAds

final class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let coinManager = CoinManager()
    private let saveRetrieveData = SaveRetrieveData()
    private let userDefaultsManager = UserDefaultsManager()
    private var arrayCurrency:[String] = []
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var bannerView: GADBannerView!
    //    var products = [SKProduct]()
    var statusRequest = false
    var localizedTitle = ""
    var localizedDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.fetchCoinPrice()
        
        let update = userDefaultsManager.retriveHourUpdate()
        setTitleLocation(updateDate: update)
        coinManager.delegate = self
        
        //        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshControlData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        //        refreshControl = self
        
        initAdMobBanner()
        
        //        IAProducts.store.requestProducts { (status, products) in
        //            if status {
        //                guard let products = products else { return }
        //                self.statusRequest = status
        //                guard let title = products.first?.localizedTitle else { return }
        //                self.localizedTitle = title
        //                guard let description = products.first?.localizedDescription else { return }
        //                self.localizedDescription = description
        //                print("Name: \(products)")
        //                self.products = products
        //            }
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
        widgetData()
    }
    
    private func widgetData() {
        if let userDefaults = UserDefaults(suiteName: "group.felipeweber.bitcoin-check.widget") {
            userDefaults.set(arrayCurrency, forKey: "keyArrayCurrency")
        }
    }
    
    @objc func refreshControlData() {
        coinManager.fetchCoinPrice()
    }
    
    
    func removeAds() {
        bannerView.removeFromSuperview()
    }
    
    //    @IBAction func buy(_ sender: Any) {
    //
    //        if statusRequest {
    //            let menu = UIAlertController(title: localizedTitle, message: localizedDescription, preferredStyle: .alert)
    //
    //            let buy = UIAlertAction(title: "Buy", style: .default) { (action) in
    //                guard let buyProduct = self.products.first else { return }
    //                IAProducts.store.buyProduct(buyProduct)
    //            }
    //            menu.addAction(buy)
    ////            let buy = UIAlertAction(title: "Buy", style: .default, handler: nil)
    ////            menu.addAction(buy)
    //            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //            menu.addAction(cancel)
    //
    //            self.present(menu, animated: true, completion: nil)
    //
    //        }
    //
    //
    //
    //        removeAds()
    //        bottonConstraint.constant = 0
    //    }
    
    
    
}


extension CurrencyViewController: GADBannerViewDelegate {
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
        
        //        let screenWidth = UIScreen.main.bounds.size.width
        //        let screenHeight = UIScreen.main.bounds.size.height
        //        print("width: \(screenWidth)")
        //        print("height: \(screenHeight)")
        
        print(view.safeAreaLayoutGuide.heightAnchor)
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //        bannerView.frame = CGRect(x: 0.0, y: screenHeight-90, width: bannerView.frame.width, height: bannerView.frame.height)
        // Testes
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        //        navigationController?.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
    }
}

extension CurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CurrencyTableViewCell
        let currency = arrayCurrency[indexPath.row]
        let result = saveRetrieveData.retrieveData(currency: currency)
        guard let price = result?.price else { return cell }
        guard let symbol = result?.symbol else { return cell }
        let priceFormat = Double(price).toCurrencyFormat()
        cell.symbolImageView.image = UIImage(imageLiteralResourceName: currency.lowercased())
        cell.setCurrencyLabel(currency, "\(symbol) \(priceFormat)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCurrency.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let lineOfTable = arrayCurrency[indexPath.row]
            userDefaultsManager.updateData(currency: lineOfTable)
            arrayCurrency.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        widgetData()
    }
}

extension CurrencyViewController: CoinManagerDelegate {
    func didUpdateData() {
        updateData()
        refreshControl.endRefreshing()
    }
    
    func didUpdateFail() {
        let title = NSLocalizedString("title", comment: "")
        let msg = NSLocalizedString("msg", comment: "")
        let cancel = NSLocalizedString("cancel", comment: "")
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let btcancel = UIAlertAction(title: cancel, style: .default, handler: nil)
        alertController.addAction(btcancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CurrencyViewController {
    private func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -5, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
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
    
    private func setTitleLocation(updateDate: String) {
        let subtitle = NSLocalizedString("setsubtitle", comment: "")
        self.navigationItem.titleView = setTitle(title: "Bitcoin check", subtitle: "\(subtitle) \(updateDate)")
    }
    
    private func updateData() {
        let update = userDefaultsManager.retriveHourUpdate()
        setTitleLocation(updateDate: update)
        arrayCurrency = userDefaultsManager.retrive()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.reloadData()
    }
}

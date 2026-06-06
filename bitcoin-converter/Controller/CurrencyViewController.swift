//
//  TableViewController.swift
//  bitcoin-converter
//

import UIKit
import StoreKit
import GoogleMobileAds

private enum RefreshState: Equatable {
    case idle
    case pulling(progress: CGFloat)
    case armed
    case loading
}

final class CurrencyViewController: UIViewController {

    private enum RefreshMetrics {
        static let threshold: CGFloat = 92
        static let maxPullDistance: CGFloat = 128
        static let pinnedInset: CGFloat = 112
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!

    private let coinManager = CoinManager()
    private let saveRetrieveData = SaveRetrieveData()
    private let userDefaultsManager = UserDefaultsManager()
    private let refreshLoaderView = PullToRefreshLoaderView()

    private var arrayCurrency: [String] = []
    private var refreshState: RefreshState = .idle
    private var baseContentInset: UIEdgeInsets = .zero
    private var baseVerticalScrollIndicatorInsets: UIEdgeInsets = .zero
    private var baseAdjustedTopInset: CGFloat = 0
    private var didCaptureBaseInsets = false

    var bannerView: BannerView!
    //    var products = [SKProduct]()
    var statusRequest = false
    var localizedTitle = ""
    var localizedDescription = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let update = userDefaultsManager.retriveHourUpdate()
        setTitleLocation(updateDate: update)
        coinManager.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        configurePullToRefresh()

        coinManager.fetchCoinPrice()

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
        super.viewDidAppear(animated)
        updateData()
        widgetData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captureBaseInsetsIfNeeded()
    }

    private func widgetData() {
        if let userDefaults = UserDefaults(suiteName: "group.felipeweber.bitcoin-check.widget") {
            userDefaults.set(arrayCurrency, forKey: "keyArrayCurrency")
        }
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

extension CurrencyViewController {
    private func configurePullToRefresh() {
        tableView.refreshControl = nil
        tableView.alwaysBounceVertical = true

        view.addSubview(refreshLoaderView)
        NSLayoutConstraint.activate([
            refreshLoaderView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            refreshLoaderView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 8)
        ])
    }

    private func captureBaseInsetsIfNeeded() {
        guard !didCaptureBaseInsets else { return }
        view.layoutIfNeeded()
        baseContentInset = tableView.contentInset
        baseVerticalScrollIndicatorInsets = tableView.verticalScrollIndicatorInsets
        baseAdjustedTopInset = tableView.adjustedContentInset.top
        didCaptureBaseInsets = true
    }

    private func pullDistance(for scrollView: UIScrollView) -> CGFloat {
        max(0, -(scrollView.contentOffset.y + scrollView.adjustedContentInset.top))
    }

    private func normalizedPullDistance(for rawPullDistance: CGFloat) -> CGFloat {
        let adjustedPullDistance = pow(max(0, rawPullDistance), 0.86) * 1.5
        return min(RefreshMetrics.maxPullDistance, adjustedPullDistance)
    }

    private func updateRefreshState(with pullDistance: CGFloat) {
        guard refreshState != .loading else { return }

        let normalizedDistance = normalizedPullDistance(for: pullDistance)
        let progress = min(1, normalizedDistance / RefreshMetrics.threshold)

        if progress <= 0 {
            setRefreshState(.idle)
        } else if progress >= 1 {
            setRefreshState(.armed, pullDistance: normalizedDistance)
        } else {
            setRefreshState(.pulling(progress: progress), pullDistance: normalizedDistance)
        }
    }

    private func setRefreshState(_ state: RefreshState,
                                 pullDistance: CGFloat = 0,
                                 animated: Bool = true) {
        refreshState = state

        switch state {
        case .idle:
            refreshLoaderView.setState(.idle, animated: animated)
        case let .pulling(progress):
            refreshLoaderView.setState(
                .pulling(progress: progress, pullDistance: pullDistance),
                animated: animated
            )
        case .armed:
            refreshLoaderView.setState(.armed(pullDistance: pullDistance), animated: animated)
        case .loading:
            refreshLoaderView.setState(.loading, animated: animated)
        }
    }

    private func beginRefreshIfNeeded() {
        guard refreshState == .armed else {
            setRefreshState(.idle)
            return
        }

        captureBaseInsetsIfNeeded()
        setRefreshState(.loading)

        UIView.animate(
            withDuration: 0.28,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            options: [.beginFromCurrentState, .allowUserInteraction]
        ) {
            self.tableView.contentInset = self.contentInsets(additionalTopInset: RefreshMetrics.pinnedInset)
            self.tableView.verticalScrollIndicatorInsets = self.verticalScrollIndicatorInsets(additionalTopInset: RefreshMetrics.pinnedInset)
            self.tableView.setContentOffset(
                CGPoint(
                    x: self.tableView.contentOffset.x,
                    y: -(self.baseAdjustedTopInset + RefreshMetrics.pinnedInset)
                ),
                animated: false
            )
        }

        coinManager.fetchCoinPrice()
    }

    private func endRefreshIfNeeded() {
        guard refreshState == .loading else { return }

        UIView.animate(
            withDuration: 0.26,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction]
        ) {
            self.tableView.contentInset = self.baseContentInset
            self.tableView.verticalScrollIndicatorInsets = self.baseVerticalScrollIndicatorInsets
        } completion: { _ in
            self.setRefreshState(.idle, animated: true)
        }
    }

    private func contentInsets(additionalTopInset: CGFloat) -> UIEdgeInsets {
        var insets = baseContentInset
        insets.top += additionalTopInset
        return insets
    }

    private func verticalScrollIndicatorInsets(additionalTopInset: CGFloat) -> UIEdgeInsets {
        var insets = baseVerticalScrollIndicatorInsets
        insets.top += additionalTopInset
        return insets
    }
}

extension CurrencyViewController: BannerViewDelegate {
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {

        //        let screenWidth = UIScreen.main.bounds.size.width
        //        let screenHeight = UIScreen.main.bounds.size.height
        //        print("width: \(screenWidth)")
        //        print("height: \(screenHeight)")

        print(view.safeAreaLayoutGuide.heightAnchor)


        bannerView = BannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //        bannerView.frame = CGRect(x: 0.0, y: screenHeight-90, width: bannerView.frame.width, height: bannerView.frame.height)
        // Testes
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"

        bannerView.rootViewController = self
        bannerView.load(Request())
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
        let currencySymbol = getSymbol(forCurrencyCode: symbol)

        let priceFormat = Double(price).toCurrencyFormat()
        cell.symbolImageView.image = UIImage(imageLiteralResourceName: currency.lowercased())
        cell.setCurrencyLabel(currency, "\(currencySymbol ?? symbol) \(priceFormat)")
        return cell
    }

    func getSymbol(forCurrencyCode code: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let localeId = Locale.availableIdentifiers.first(where: {
            Locale(identifier: $0).currencyCode == code
        })

        if let localeId = localeId {
            formatter.locale = Locale(identifier: localeId)
            return formatter.currencySymbol
        }

        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayCurrency.count
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

extension CurrencyViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableView else { return }

        if refreshState != .loading && !scrollView.isDragging {
            setRefreshState(.idle)
            return
        }

        updateRefreshState(with: pullDistance(for: scrollView))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView === tableView else { return }

        let releaseDistance = normalizedPullDistance(for: pullDistance(for: scrollView))

        if releaseDistance >= RefreshMetrics.threshold {
            setRefreshState(.armed, pullDistance: releaseDistance, animated: false)
            beginRefreshIfNeeded()
        } else if !decelerate {
            setRefreshState(.idle)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === tableView, refreshState != .loading else { return }

        if pullDistance(for: scrollView) <= 0 {
            setRefreshState(.idle)
        }
    }
}

extension CurrencyViewController: CoinManagerDelegate {
    func didUpdateData() {
        updateData()
        endRefreshIfNeeded()
    }

    func didUpdateFail() {
        endRefreshIfNeeded()

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
    private func setTitle(title: String, subtitle: String) -> UIView {
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

        if arrayCurrency.isEmpty {
            showEmptyState()
        } else {
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableView.backgroundView = nil
        }

        tableView.reloadData()
    }

    private func showEmptyState() {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))

        emptyView.backgroundColor = .bitcoinBlue

        let mainContainer = UIView()
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addSubview(mainContainer)

        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: "currency.exchange")
        iconView.tintColor = .white.withAlphaComponent(0.5)
        iconView.contentMode = .scaleAspectFit
        mainContainer.addSubview(iconView)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = NSLocalizedString("no_currencies_selected", comment: "")
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        mainContainer.addSubview(titleLabel)

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = NSLocalizedString("no_currencies_selected_description", comment: "")
        descriptionLabel.textColor = .white.withAlphaComponent(0.7)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        mainContainer.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            mainContainer.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            mainContainer.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 16),
            mainContainer.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -16),

            iconView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            iconView.centerXAnchor.constraint(equalTo: mainContainer.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 96),
            iconView.heightAnchor.constraint(equalToConstant: 96),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])

        tableView.backgroundView = emptyView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

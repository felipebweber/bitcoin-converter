//
//  IAHelper.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 05/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAHelper: NSObject {
    
    static let IAHelperPurchaseNotification = "IAHelperPurchaseNotification"
    fileprivate let productIdentifier: Set<ProductIdentifier>
    fileprivate var purchasedProductIdenfier = Set<ProductIdentifier>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductRequestCompletionHandler?
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifier = productIds
        for productId in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productId)
            if purchased {
                print("Já comprado: \(productIds)")
            } else {
//                let teste = SKPayment(product: productId)
//                SKPaymentQueue.default().add(self)
                print("Ainda não comprado: \(productIds)")
            }
        }
    }
}

extension IAHelper {

    public func requestProducts(completionHandler: @escaping ProductRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifier)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Name: \(product.localizedTitle)")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension IAHelper:  SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
}

extension IAHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                print("Failed")
                break
            case .restored:
                print("Restored")
                break
            case .purchasing:
                print("Purchasing")
                break
            case .deferred:
                print("Defered")
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Completo")
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        print("Restaurado")
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(trasanction: SKPaymentTransaction) {
        print("Fail")
        if let transactionError = trasanction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Erro na transação: \(trasanction.error?.localizedDescription)")
            }
        }
        SKPaymentQueue.default().finishTransaction(trasanction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdenfier.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAHelper.IAHelperPurchaseNotification), object: identifier)
    }
}

//
//  IAProducts.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 05/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

public struct IAProducts {
    
    public static let firstIAP: ProductIdentifier = "com.felipeweber.bitcoin.check.removebannerbitcoin"
    
    fileprivate static let productIdentifier: Set<ProductIdentifier> = [IAProducts.firstIAP]
    
    public static let store = IAHelper(productIds: IAProducts.productIdentifier)
    
}

func resourseNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

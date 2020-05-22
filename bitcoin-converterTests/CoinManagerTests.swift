//
//  CoinManagerTests.swift
//  bitcoin-converterTests
//
//  Created by Felipe Weber on 21/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import XCTest
import CoreData
import Cuckoo

@testable import bitcoin_converter

class CoinManagerTests: XCTestCase {
    
    let mock = MockCoinManager()
    
    
    
    //let spy = MockCoinManager().withEnabledDefaultImplementation(<#T##stub: CoinManager##CoinManager#>)
    //let spy = MockCoinManager().withEnabledSuperclassSpy()
    
    
    
//    var manageResult: NSFetchedResultsController<CoinEntity>?
    
//    let coinManager = CoinManager()
    
    override func setUp() {
        stub(mock) { (stub) in
            when(stub.fetchCoinPrice()).thenCallRealImplementation()
            }
        }
    
//    stub(coinManager) { (coinManager) in
//        when(coinManager.fetchCoinPrice()).thenReturn([])
//    }
    
    func testRequestUrl() {
        
        mock.enableDefaultImplementation(mock)
        
        when(mock.currentArray.count)
//        stub(mock) { (stub) in
//            when(stub.fetchCoinPrice()).thenDoNothing()
//        }
    }
}

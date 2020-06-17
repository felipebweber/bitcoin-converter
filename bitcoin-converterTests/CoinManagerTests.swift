//
//  CoinManagerTests.swift
//  bitcoin-converterTests
//
//  Created by Felipe Weber on 16/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import XCTest
@testable import Bitcoin_Check

class CoinManagerTests: XCTestCase {
    
    var sut: CoinManager!
    
    override func setUp() {
        super.setUp()
        sut = CoinManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCoinManager_whenDate_isFormattedString() {
        let calendar = Calendar.current
        let dateComponets = DateComponents(calendar: calendar, year: 2020, month: 6, day: 16, hour: 22, minute: 44)
        let date = calendar.date(from: dateComponets)
        let dateFormatted = date!.formattedHour()
        XCTAssertEqual("6/16/20, 10:44 PM" , dateFormatted)
    }
    
    func testCoinManger_whenParsed() {
        let dictionary: [String: Any] = [ "USD" : ["15m" : 9503.76, "last" : 9503.76, "buy" : 9503.76, "sell" : 9503.76, "symbol" : "$"] ]
        let usd = "USD"
        let price = 9503.76
        let symbol = "$"
        
        let listCoin = sut.parseJSON(dictionary)
        
        XCTAssertEqual(usd, listCoin.first?.currency)
        XCTAssertEqual(price, listCoin.first?.value)
        XCTAssertEqual(symbol, listCoin.first?.symbol)
    }
}

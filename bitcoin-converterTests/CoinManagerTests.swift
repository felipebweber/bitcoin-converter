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
}

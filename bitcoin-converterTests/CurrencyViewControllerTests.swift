//
//  CurrencyViewControllerTests.swift
//  bitcoin-converterTests
//
//  Created by Felipe Weber on 16/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import XCTest
@testable import Bitcoin_Check

class CurrencyViewControllerTests: XCTestCase {

    func testCurrency_whenValue_isFormattedTen() {
        let value = 16.06
        let valueFormatted = value.toCurrencyFormat()
        XCTAssertEqual("16.06", valueFormatted)
        XCTAssertNotEqual("16.10", valueFormatted)
    }
    
    func testCurrency_whenValue_isFormattedHundreds() {
        let value = 165.06
        let valueFormatted = value.toCurrencyFormat()
        XCTAssertEqual("165.06", valueFormatted)
        XCTAssertNotEqual("165.86", valueFormatted)
    }
    
    func testCurrency_whenValue_isFormattedThousands() {
        let value = 12345.67
        let valueFormatted = value.toCurrencyFormat()
        XCTAssertEqual("12,345.67", valueFormatted)
        XCTAssertNotEqual("12,345.99", valueFormatted)
    }
}

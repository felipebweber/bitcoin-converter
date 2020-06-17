//
//  ConfigTests.swift
//  bitcoin-converterTests
//
//  Created by Felipe Weber on 16/06/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import XCTest
@testable import Bitcoin_Check

class ConfigTests: XCTestCase {

    var sut: Config!
    
    override func setUp() {
        super.setUp()
        sut = Config()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testConfig_whenGetUrl_isReturnUrlString() {
        let url = sut.getUrlStandard()
        XCTAssertEqual("https://blockchain.info/ticker", url)
    }
}

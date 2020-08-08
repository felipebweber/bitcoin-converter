//
//  CoinDataResponse.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 02/07/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import Foundation

class CoinDataResponse: Codable {
    let id: String
    let symbol: String
    let market_data: Market_data
}

extension CoinDataResponse {
    struct Market_data: Codable {
        let current_price: [String: Double]
    }

    struct balasJuquinhas: Codable {
        let usd: Double
        let brl: Double
        let aud: Double
        let cad: Double
        let chf: Double
        let clp: Double
        let cny: Double
        let dkk: Double
        let eur: Double
        let gbp: Double
        let hkd: Double
        let inr: Double
        let isk: Double
        let jpy: Double
        let krw: Double
        let nzd: Double
        let pln: Double
        let rub: Double
        let sek: Double
        let sgd: Double
        let thb: Double
        let `try`: Double
        let twd: Double
    }

}

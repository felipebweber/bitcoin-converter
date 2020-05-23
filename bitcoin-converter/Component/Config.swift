//
//  Config.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 22/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

class Config: NSObject {

    func getUrlStandard() -> String? {
        guard let pathOfPlist = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        guard let dictionary = NSDictionary(contentsOfFile: pathOfPlist) else { return nil }
        guard let urlStandard = dictionary["UrlStandard"] as? String else { return "" }
        return urlStandard
    }
}

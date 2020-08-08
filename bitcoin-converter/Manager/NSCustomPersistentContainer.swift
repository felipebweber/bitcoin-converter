//
//  NSCustomPersistentContainer.swift
//  bitcoin-converter
//

import Foundation
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.felipeweber.bitcoin-check.widget")
        storeURL = storeURL?.appendingPathComponent("CoinEntity")
        return storeURL!
    }
}

//
//  ViewController.swift
//  BTConverter
//
//  Created by Felipe Weber on 15/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCurency: UILabel!
    @IBOutlet weak var currentPicker: UIPickerView!
    @IBOutlet weak var updateDate: UILabel!
    
    var coinManager = CoinManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currentPicker.delegate = self
        currentPicker.dataSource = self
        
        coinManager.fetchCoinPrice()
        updateDate.text = "Atualizado as: \(getHour(Date()))"
    }
    
    func getHour(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currentArray.count
    }
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let select = coinManager.currentArray[row]
        print("Select: \(select)")
        coinManager.retrieveData(currency: select)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currentArray[row]
    }
}

extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.labelPrice.text = price
            self.labelCurency.text = currency
        }
    }
}

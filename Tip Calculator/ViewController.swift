//
//  ViewController.swift
//  Tipper
//
//  Created by Harjas Monga on 12/4/17.
//  Copyright © 2017 Harjas Monga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var splitBill2: UILabel!
    @IBOutlet weak var numOfChecksLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    let percentages = [0.18, 0.2, 0.25]
    var tipIndex = 0
    let currencyFormatter = NumberFormatter()
    var customTip = 0.0;
    var numOfChecks = 2
    var useCustomTip = false
    var tipPercentage = 0.0;
    let clearTime = 600.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up number formatter to internalionalize the price
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = Locale.current
        // set the place holder based on location
        billTextField.placeholder = currencyFormatter.currencySymbol
        // set text fields to automatically adjust font size to fit in the set width
        tipLabel.adjustsFontSizeToFitWidth = true
        totalLabel.adjustsFontSizeToFitWidth = true
        numOfChecksLabel.adjustsFontSizeToFitWidth = true
        tipPercentLabel.adjustsFontSizeToFitWidth = true
        splitBill2.adjustsFontSizeToFitWidth = true
        numOfChecksLabel.adjustsFontSizeToFitWidth = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // automatically set the input text field once the app opens
        billTextField.becomeFirstResponder()
        // load initial saved values
        tipIndex = userDefaults.integer(forKey: "tipIndex")
        customTip = userDefaults.double(forKey: "customTip")
        billTextField.text = userDefaults.string(forKey: "lastBill")
        //clears bill if it was last entered an hour ago
        let lastUse = userDefaults.object(forKey: "lastUpdate") as? Date ?? Date()
        if -1 * lastUse.timeIntervalSinceNow < clearTime {
            print("load last bill")
            billTextField.text = userDefaults.string(forKey: "lastBill")
        } else {
            print("clearing last bill")
            billTextField.text = ""
            userDefaults.set("", forKey: "lastBill")
        }
        numOfChecks = userDefaults.integer(forKey: "numOfChecks")
        useCustomTip = userDefaults.bool(forKey: "useCustomTip")
        // set tip percentage based on user selection
        if useCustomTip {
            tipPercentage = customTip
        } else {
            tipPercentage = percentages[tipIndex]
        }
        // initalize tip percentage label
        tipPercentLabel.text = String(format: "%.0f%%", tipPercentage * 100)
        // calculate tip based on saved information
        updateValues()
    }
    // function is a called every time the bill value is updated
    @IBAction func onEdit(_ sender: Any) {
        // calculates the tip based on new input
        updateValues()
        // saves bill text field value
        userDefaults.set(billTextField.text!, forKey: "lastBill")
        // saves the last time the bill was updated
        userDefaults.set(Date(), forKey: "lastUpdate")

    }
    // calculates the tip based on changes to the input
    func updateValues() {
        // reads value from bill text field. sets bill to that value if possibile, if not sets it to 0
        let bill = Double(billTextField.text!) ?? 0
        let tip = tipPercentage * bill
        // sets tip and total price label values based on new bill value
        tipLabel.text = currencyFormatter.string(from: NSNumber(value: tip))
        totalLabel.text = currencyFormatter.string(from: NSNumber(value: bill + tip))
        if numOfChecks > 1 {
            numOfChecksLabel.text = String(numOfChecks) + " Checks:"
            splitBill2.text = currencyFormatter.string(from: NSNumber(value: (bill + tip) / Double(numOfChecks)))
        } else {
            numOfChecksLabel.text = "2 Checks:"
            splitBill2.text = currencyFormatter.string(from: NSNumber(value: (bill + tip) / 2))
        }
    }
}


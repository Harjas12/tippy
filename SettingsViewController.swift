//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by Harjas Monga on 12/7/17.
//  Copyright © 2017 Harjas Monga. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var useCustomTip: UISwitch!
    @IBOutlet weak var percentageControl: UISegmentedControl!
    @IBOutlet weak var checksLabel: UITextField!
    @IBOutlet weak var customTipLabel: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadSettings()
    }
    // prepopulates settings view with saved settings
    func loadSettings() {
        percentageControl.selectedSegmentIndex = userDefaults.integer(forKey: "tipIndex")
        checksLabel.text = String(userDefaults.integer(forKey: "numOfChecks"))
        useCustomTip.isOn = userDefaults.bool(forKey: "useCustomTip")
        customTipLabel.text = String(format: "%.0f", userDefaults.double(forKey: "customTip") * 100)
    }
    // makes keyboard disappear
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    //saves new number of checks for the split check calculation
    @IBAction func numOfCheckChanged(_ sender: Any) {
        userDefaults.set(Int(checksLabel.text!), forKey: "numOfChecks")
    }
    //saves the new custom tip value
    @IBAction func updateCustomTip(_ sender: Any) {
        let customTip = (Double(customTipLabel.text!) ?? 0) / 100
        userDefaults.set(customTip, forKey: "customTip")
    }
    //saves the new bool to use the custom tip or not
    @IBAction func updateCustomTipBoolean(_ sender: Any) {
        let toUseCustomTip = useCustomTip.isOn
        userDefaults.set(toUseCustomTip, forKey: "useCustomTip")
    }
    //saves the default percentage
    @IBAction func updateDefaultPercentage(_ sender: Any) {
        userDefaults.set(percentageControl.selectedSegmentIndex, forKey: "tipIndex")
        print("tip index default set to: " + String(userDefaults.integer(forKey: "tipIndex")))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

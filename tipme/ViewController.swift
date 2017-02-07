//
//  ViewController.swift
//  tipme
//
//  Created by LVMBP on 2/6/17.
//  Copyright © 2017 vulong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSelect: UISegmentedControl!

    var selectedValue = 0
    var badValue = 0
    var normalValue = 0
    var goodValue = 0
    var tipPercent = [0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        calculateTip()
    }

    func calculateTip(){
        let bill = Double(billTextField.text!) ?? 0
        let tip = bill * Double(tipPercent[tipSelect.selectedSegmentIndex]) / 100
        let total = bill + tip
        tipLabel.text = String(format: "$%.2f",tip)
        totalLabel.text = String(format: "$%.2f",total)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let settings = UserDefaults.standard
        //for custom UI display
        selectedValue = settings.integer(forKey: "tipme_selected_location") ?? 0
        
        //getting values for recommended tip amount by country
        badValue = settings.integer(forKey: "tipme_bad_value") ?? 0
        normalValue = settings.integer(forKey: "tipme_normal_value") ?? 0
        goodValue = settings.integer(forKey: "tipme_good_value") ?? 0
        tipSelect.setTitle(String(badValue)+"%", forSegmentAt: 0)
        tipSelect.setTitle(String(normalValue)+"%", forSegmentAt: 1)
        tipSelect.setTitle(String(goodValue)+"%", forSegmentAt: 2)
        tipPercent[0] = badValue
        tipPercent[1] = normalValue
        tipPercent[2] = goodValue
        
        //checking last bill amount last saved time
        let billAmount = settings.string(forKey: "bill_amount") ?? ""
        if (billAmount.characters.count > 0)
        {
            let savedTimeValue = settings.string(forKey: "bill_saved_date")
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .medium
            let savedDate = formatter.date(from: savedTimeValue!)
            let currentDateTime = Date()
            let diffMinute = currentDateTime.timeIntervalSince(savedDate!)/60
//        print("bill amount saved "+String(diffMinute)+" ago")
            if (diffMinute <= 10){
                billTextField.text = billAmount
                print("bill amount saved "+String(diffMinute)+" ago. Displaying to text field")
            }
            else
            {
                print("bill amount saved "+String(diffMinute)+" ago. Ignore saved data")
            }
        }
        billTextField.becomeFirstResponder()
//        print("Using default value "+String(selectedValue))
//        print("Values=> bad: "+String(badValue)+" normal: "+String(normalValue)+" good: "+String(goodValue))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let settings = UserDefaults.standard
        settings.set(billTextField.text!, forKey: "bill_amount")

        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        
        // get the date time String from the date object
        let savedTime = formatter.string(from: currentDateTime)
        
        settings.set(savedTime, forKey: "bill_saved_date")
        print("Saved bill value "+billTextField.text!+" at "+savedTime)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateTip()
    }
}


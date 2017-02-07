//
//  SettingsViewController.swift
//  tipme
//
//  Created by LVMBP on 2/6/17.
//  Copyright © 2017 vulong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var badLabel: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var badValueField: UITextField!
    @IBOutlet weak var normalValueField: UITextField!
    @IBOutlet weak var goodValueField: UITextField!
    var defaultValues = [0,10,20]
    let usaValue = [15,20,25]
    let ukValue = [20,25,30]
    let vnValue = [0,0,50]
    let locationArray = ["Custom","USA", "UK", "Vietnam"]
    let textLocValue = "LocCell"
    @IBOutlet weak var locationView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationView.delegate = self
        locationView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setCustomAmounts(_ sender: AnyObject) {
        let badValue = Int(badValueField.text!) ?? 0
        let normalValue = Int(normalValueField.text!) ?? 0
        let goodValue = Int(goodValueField.text!) ?? 0
        print("Custom value changed. Bad: "+String(badValue)+" Normal: "+String(normalValue)+" Good: "+String(goodValue))
        defaultValues[0] = badValue
        defaultValues[1] = normalValue
        defaultValues[2] = goodValue
        let settings = UserDefaults.standard
        settings.set(badValue, forKey: "tipme_custom_bad_value")
        settings.set(normalValue, forKey: "tipme_custom_normal_value")
        settings.set(goodValue, forKey: "tipme_custom_good_value")
        settings.synchronize()
    }

    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textLocValue, for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = locationArray[row]
        if row == selectedValue
        {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
            fillValuesToTextBoxes(valueArray: locationValueArray[row])
        }
        return cell
    }
    func fillValuesToTextBoxes(valueArray: Array<Any>){
        badValueField.text = String(format: "%i",valueArray[0] as! CVarArg)
        normalValueField.text = String(format: "%i",valueArray[1] as! CVarArg)
        goodValueField.text = String(format: "%i",valueArray[2] as! CVarArg)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        let row = indexPath.row
//        print(locationArray[row])
        if row == 0
        {
            badValueField.isEnabled = true
            normalValueField.isEnabled = true
            goodValueField.isEnabled = true
        }
        else
        {
            badValueField.isEnabled = false
            normalValueField.isEnabled = false
            goodValueField.isEnabled = false
        }
        fillValuesToTextBoxes(valueArray: locationValueArray[row])
        saveSettings(selectedValue: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        let row = indexPath.row
//        print("uncheck "+locationArray[row])
    }
    
    func saveSettings(selectedValue: Int){
        let settings = UserDefaults.standard
        settings.set(selectedValue, forKey: "tipme_selected_location")
        saveSelectedTipAmounts()
    }
    var selectedValue = 0
    var locationValueArray = [Array<Any>]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let settings = UserDefaults.standard
        //getting saved location
        selectedValue = settings.integer(forKey: "tipme_selected_location")
        if selectedValue == 0
        {
            badValueField.isEnabled = true
            normalValueField.isEnabled = true
            goodValueField.isEnabled = true
        }
        else
        {
            badValueField.isEnabled = false
            normalValueField.isEnabled = false
            goodValueField.isEnabled = false
        }
//        print("previously selected "+String(selectedValue))
        //getting saved custom values
        let savedBadValue = settings.integer(forKey: "tipme_custom_bad_value")
        let savedNormalValue = settings.integer(forKey: "tipme_custom_normal_value")
        let savedGoodValue = settings.integer(forKey: "tipme_custom_good_value")
        defaultValues[0] = savedBadValue
        defaultValues[1] = savedNormalValue
        defaultValues[2] = savedGoodValue
        
        locationValueArray = [defaultValues,usaValue,ukValue,vnValue]
    }
    func saveSelectedTipAmounts()
    {
        let settings = UserDefaults.standard
        settings.set(badValueField.text, forKey: "tipme_bad_value")
        settings.set(normalValueField.text, forKey: "tipme_normal_value")
        settings.set(goodValueField.text, forKey: "tipme_good_value")
        settings.synchronize()
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveSelectedTipAmounts()
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

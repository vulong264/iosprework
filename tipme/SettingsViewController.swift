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
    let defaultValues = [0,10,20]
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
        print(locationArray[row])
        fillValuesToTextBoxes(valueArray: locationValueArray[row])
        saveSettings(selectedValue: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        let row = indexPath.row
        print("uncheck "+locationArray[row])
    }
    
    func saveSettings(selectedValue: Int){
        let settings = UserDefaults.standard
        settings.set(selectedValue, forKey: "tipme_selected_location")
        settings.set(badValueField.text, forKey: "tipme_bad_value")
        settings.set(normalValueField.text, forKey: "tipme_normal_value")
        settings.set(goodValueField.text, forKey: "tipme_good_value")
        settings.synchronize()
    }
    var selectedValue = 0
    var locationValueArray = [Array<Any>]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let settings = UserDefaults.standard
        selectedValue = settings.integer(forKey: "tipme_selected_location")
        print("previously selected "+String(selectedValue))
        locationValueArray = [defaultValues,usaValue,ukValue,vnValue]
        badLabel.text = ":-("
        normalLabel.text = ":-|"
        goodLabel.text = ":-)"

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

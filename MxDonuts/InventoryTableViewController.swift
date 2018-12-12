//
//  InventoryTableViewController.swift
//  MxDonuts
//
//  Created by Liya Norng on 10/8/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit

class InventoryTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   

    var instance = Record.instance
    var reload = false
    private var inventoryItemName:[String] = []
    private var inventoryItemTotal:[String] = []
    var didSelectedAmount = "0"
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if (self.instance.getUser().getNameListToCheck().isEmpty){
            self.readInputFromFile()
        }
        self.startTheProcess()
    }
    
    func startTheProcess()->Void{
        if (self.instance.getUser().checkForItemInInventoryItemWithKey(date: self.instance.getUser().getCurrentDate())){
            self.inventoryItemTotal = self.instance.getUser().getCurrentInventory().getItemTotal()
            self.inventoryItemName = self.instance.getUser().getCurrentInventory().getItemName()
        }
        else {
            for i in 0..<51{
                inventoryItemTotal.insert("0", at: i)
            }
            self.inventoryItemName = self.instance.getUser().getNameListToCheck()
        }
    }
    
    func getDate(date:Date)->String{
        let format = DateFormatter()
        format.dateFormat = "MMMM,dd,yyyy"
        let str = format.string(from: date )
        return str
    }
    
    
    @IBAction func restartTheInventory(_ sender: UIBarButtonItem) {
    
        let alerts = UIAlertController(title: "Restart: \"", message: "\nAre you sure you want to restart over again?\n\n", preferredStyle: .alert)
        
        alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
            
            self.reload = true
            self.startTheProcess()
            
        }))
        self.present(alerts,animated: true, completion: nil )
    }
    
//    
//    @IBAction func addNewItemToInventory(_ sender: UIBarButtonItem) {
//    
//        let alerts = UIAlertController(title: "New Item : ", message: "\n", preferredStyle: .alert)
//        
//        let uiTextView = UITextView(frame: CGRect(x: 0, y: 60, width: 270, height: 25))
//        alerts.view.addSubview(uiTextView)
//        uiTextView.adjustsFontForContentSizeCategory = false
//        uiTextView.resignFirstResponder()
//        alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
//            
//            self.reload = true
//            self.instance.getUser().addNameListToCheck(newItemName: uiTextView.text!)
//            self.inventoryItemName.append(uiTextView.text!)
//        }))
//        self.present(alerts,animated: true, completion: nil )
//    }
    
    
    @IBAction func doneWithInventory(_ sender: UIBarButtonItem) {
    
        let instance = Record.instance
    
        instance.getUser().getCurrentInventory().setItemTotal(itemTotal: self.inventoryItemTotal)
        instance.getUser().getCurrentInventory().setItemName(item: self.inventoryItemName)
        instance.getUser().addInventoryItemAccordingToDate()
        
        performSegue(withIdentifier: "backToMainFromInventorySegue", sender: nil)
    }
    
    func readInputFromFile()->Void {
        
        if let filepath = Bundle.main.path(forAuxiliaryExecutable: "listOfItems.txt"){
            if let contents = try? String(contentsOfFile: filepath){
                self.inventoryItemName = contents.components(separatedBy: .newlines)
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Oooops! Something went wrong: (error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Back", style: .default , handler:{(action) in
                    self.performSegue(withIdentifier: "errorReadingFileSegue", sender: nil)
                }))
            }
        }
        self.inventoryItemName.removeLast()
        self.instance.successful = true
        self.instance.getUser().setNameListToCheck(nameListToCheck: self.inventoryItemName)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 51
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row )"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.didSelectedAmount = "\(row)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryItemName.count
    }
    
    override func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath!)
        cell.textLabel?.text = self.didSelectedAmount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
        
        cell.textLabel?.text = self.inventoryItemName[row]
        
        cell.detailTextLabel?.text = self.inventoryItemTotal[row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.reload){
            tableView.reloadData()
            self.reload = false
        }
        
        let alerts = UIAlertController(title: "Total Amount of :", message: "\n \"\(inventoryItemName[indexPath.row])\"\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 60, width: 250, height: 200))
        alerts.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
            
            self.inventoryItemTotal[indexPath.row] = self.didSelectedAmount
            tableView.reloadData()
            
        }))
        self.present(alerts,animated: true, completion: nil )
    }
    

}

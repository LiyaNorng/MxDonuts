//
//  TextFormatOfItem.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/20/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit

class TextFormatOfItem: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let instance = Record.instance
    private var itemName:[String] = []
    private var itemNameForReferrence:[String] = []
    private var itemTotal:[String] = []
    @IBOutlet weak var labelForDate: UILabel!
    var date = Date()
    var selectedRow = -1
    var addingItemName = true
    var newItemName:String = ""
    var newItemTotal:String = "0"
    var reload  = false

    @IBAction func editUIButton(_ sender: UIBarButtonItem) {
        self.addingItemName = false
        
        
        if (self.selectedRow != -1){
            let alerts = UIAlertController(title: "Edit Amount correlate to : ", message: "\n\n\"\(self.itemName[self.selectedRow])\"\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            
            let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 60, width: 250, height: 200))
            alerts.view.addSubview(pickerFrame)
            pickerFrame.dataSource = self
            pickerFrame.delegate = self
            
            alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
                
                for i in 0..<self.itemName.count{
                    
                    if (self.itemName[i] == self.itemName[self.selectedRow]){
                        self.itemTotal[i] = self.newItemTotal
                        self.reload = true
                        break;
                    }
                }
                self.selectedRow = -1
            }))
            self.present(alerts,animated: true, completion: nil )
        }
        else {
            
            let alerts = UIAlertController(title: "Edit", message: "\n\nPlease select an item to edit the amount.\n\n\n", preferredStyle: .alert)
            self.selectedRow = -1
            alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alerts,animated: true, completion: nil )
        }
    }
    
    func saveData()->Void{
        
        do {
            let url = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
            
            let path = url.path + "/MxDonuts.data"
            NSKeyedArchiver.archiveRootObject(self.instance, toFile: path)
            print ("\(path)")
            
        } catch {
            print ("Something went wrong: \(error)")
        }
    }
    
    
    @IBAction func userAdditionalOption(_ sender: UIBarButtonItem) {

        if (sender.tag == 0){
            // trash
            self.alert()
        }
        else if (sender.tag == 1){
            // sign out
            self.deleteTextFile(fileName: "MxDonuts", fileType: "txt")
            self.saveData()
            performSegue(withIdentifier: "signOutSegue", sender: nil)
        }
        else if (sender.tag == 2){
            // Done
            self.deleteTextFile(fileName: "MxDonuts", fileType: "txt")
            self.saveData()
            performSegue(withIdentifier: "backToMainMenuSegue", sender: nil)
        }
        else if (sender.tag == 3){
            // add
            self.addName()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (self.addingItemName){
            return self.itemNameForReferrence.count
        }
        return 51
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (self.addingItemName){
            if (row == 0){
                return ""
            }
            return self.itemNameForReferrence[row]
        }
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (self.addingItemName){
            if (row == 0){
                self.newItemName = ""
            }
            else {
                self.newItemName = self.itemNameForReferrence[row]
            }
        }
        else {
            self.newItemTotal = "\(row)"
        }
    }
    
    func addName()->Void{
        
        self.addingItemName = true
        let alerts = UIAlertController(title: "Adding new Item:", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 60, width: 250, height: 200))
        alerts.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
            
            for i in 0..<self.itemName.count{
               
                if (self.newItemName == ""){
                    self.addingItemName = false
                    break;
                }
                else {
                    if (self.itemName[i] == self.newItemName){
                        self.errorName()
                        self.addingItemName = false
                        break;
                    }
                }
            }
            if (self.addingItemName){
                self.addTotal()
            }
            self.selectedRow = -1
        }))
        self.present(alerts,animated: true, completion: nil )
    
    }
    
    func errorName()->Void{
        
        let alerts = UIAlertController(title: "Error: ", message: "\nThere is already exist an item of : \n\n\"\(self.newItemName)\"\n\n\n\n\n", preferredStyle: .alert)
        self.selectedRow = -1
        alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alerts,animated: true, completion: nil )
        
    }
    
    func addTotal()->Void{
        self.addingItemName = false
        let alerts = UIAlertController(title: "Adding New Amount To New Item: ", message: "\n\"\(self.newItemName)\"\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 0, y: 60, width: 250, height: 200))
        alerts.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
            self.itemName.append(self.newItemName)
            self.itemTotal.append(self.newItemTotal)
            self.reload = true
            self.selectedRow = -1
        }))
        self.present(alerts,animated: true, completion: nil )
    }
    
    
    @IBAction func selectOptin(_ sender: UIBarButtonItem) {
        
        self.deleteTextFile(fileName: "MxDonuts", fileType: "txt")
        //self.writeToFile()
        
        self.writeToWorkExcel()
        let fileName = "MxDonuts"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")

        let activityItem:NSURL = NSURL(fileURLWithPath: fileURL.path)
        
        let activityController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil )
        
    }
    
    func writeToWorkExcel()->Void{
        let fileName = "MxDonuts"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil , create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        var contents = ("Mx Donuts,\n")
        contents.append("15126 Harlan Road,\n")
        contents.append("Lathrop CA. 95330 USA,\n")
        contents.append("Tell: 1(209) 858-2283,\n")
        contents.append("\(self.getTodayDayInDayAndMonthForExcel(date: self.instance.getUser().getCurrentDate())),\n")
        contents.append("\n")
        contents.append("\n")
        contents.append("Slot,Descripton,Quantity,\n")
        
        for i in 0..<self.itemName.count{
            if (self.itemTotal.count == i){
                contents.append(contentsOf: "\(i + 1).) ,\(self.itemName[i]),\(self.itemTotal[i]),")
                break;
            }
            contents.append(contentsOf: "\(i + 1).) ,\(self.itemName[i]),\(self.itemTotal[i]),\n")
        }
        
        do {
            try contents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8 )
        }
        catch  {
            print("Error of writing to file.")
        }
    }
    
    func deleteTextFile(fileName:String, fileType:String)->Void{
        
        let fileManager = FileManager.default
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileType)
        do {
            try fileManager.removeItem(atPath: fileURL.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func getTodayDayInDayAndMonthForExcel(date:Date)->String{
        let format = DateFormatter()
        format.dateFormat = "EEEE MMMM dd yyyy"
        let str = format.string(from: self.instance.getUser().getCurrentDate())
        return str
    }
    
    func getTodayDayInDayAndMonth(date:Date)->String{
        let format = DateFormatter()
        format.dateFormat = "EEEE, MMMM dd, yyyy"
        let str = format.string(from: self.instance.getUser().getCurrentDate())
        return str
    }
    
    func writeToFile()->Void{
        self.deleteTextFile(fileName: "MxDonuts", fileType: "txt")
        
        let fileName = "MxDonuts"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")

        var contents = ""
        contents.append("Mx Donuts\n")
        contents.append("15126 Harlan Road\n")
        contents.append("Lathrop, CA. 95330 USA\n")
        contents.append("Tell: 1(209) 858-2283 \n")
        contents.append("\(self.getTodayDayInDayAndMonth(date: self.instance.getUser().getCurrentDate()))\n")
        contents.append("\n")
        contents.append("\n")
        contents.append("\n")
        contents.append("Supplies Sheet:\n")
        contents.append("\n")
        contents.append("\n")

        for i in 0..<self.itemName.count{
            if (self.itemTotal[i] != "0"){
                contents.append(contentsOf: "\(i + 1).) \(self.itemName[i])_ _ _ _ _ _ _ _ _ _ _\(self.itemTotal[i])\n")
            }
        }
    
        do {
            try contents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch  {
            print("Error of writing to file.")
        }
    }
    
    override func viewDidLoad() {
        
        self.setUpState()
    }
    
    func setUpState()->Void{
        self.getDate()
        self.itemName = self.instance.getUser().getItems().getItemName()
        self.itemTotal = self.instance.getUser().getItems().getItemTotal()
        self.itemNameForReferrence = self.itemName
        
        var tmpItemTotal:[String] = []
        var tmpItemName:[String] = []
        for i in 0..<self.itemName.count{
            
            if (self.itemTotal[i] != "0"){
                print ("\(self.itemName.count)\n")
                print ("\(i)\n")
                tmpItemName.append(self.itemName[i])
                tmpItemTotal.append(self.itemTotal[i])
            }
        }
        self.itemName.removeAll()
        self.itemTotal .removeAll()
        self.itemName = tmpItemName
        self.itemTotal = tmpItemTotal
    }
    
    
    /*
    func writeItemsToList()->Void{
        
        for i in 0..<self.itemName.count{
            
            if (self.itemTotal[i] != "0"){
                self.textViewOfItem.text.append("\(self.itemName[i])_____________\(self.itemTotal[i])\n")
            }
        }
    }
 
 */
    
    func getDate()->Void{
        let format = DateFormatter()
        format.dateFormat = "EEEE, MMMM dd, yyyy HH:mm a"
        let str = format.string(from: self.instance.getUser().getCurrentDate())
        self.labelForDate.text = str
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemName.count
    }
    
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightDetail", for: indexPath)
        cell.textLabel?.text = self.itemName[row]
        cell.detailTextLabel?.text = self.itemTotal[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedRow = -1
        if (self.reload){
            tableView.reloadData()
            self.reload = false
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedRow = -1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.reload){
            tableView.reloadData()
            self.reload = false
        }
        self.selectedRow = indexPath.row
    }
    
    func alert()->Void{
        
        if (self.selectedRow == -1){
            let alerts = UIAlertController(title: "Delete ", message: "\nPlease select an item to delete.\n\n\n", preferredStyle: .alert)
            alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.selectedRow = -1
            self.present(alerts,animated: true, completion: nil )

        }
        else {
            let alerts = UIAlertController(title: "Are sure you want to delete?", message: "\n\n\"\(self.itemName[self.selectedRow])\"\n\n\n\n", preferredStyle: .alert)
            alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
                    self.itemName.remove(at: self.selectedRow)
                    self.itemTotal.remove(at: self.selectedRow)
                    self.reload = true
                    self.selectedRow = -1
            }))
            self.present(alerts,animated: true, completion: nil )
        }
    }
}

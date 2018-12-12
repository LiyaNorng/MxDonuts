//
//  ListOfDates.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/20/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit

class ListOfDates: UITableViewController{
    
    private var dates:[Date] = []
    let instance:Record = Record.instance
    var didSelected = -1
    override func viewDidLoad(){
        super.viewDidLoad()
        self.dates = self.instance.getUser().getDates()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    override func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = self.getDate(date: dates[row])

        return cell
    }
    
    func getDate(date:Date)->String{
        let format = DateFormatter()
        format.dateFormat = "EEEE, MMMM dd,yyyy HH:mm a"
        let str = format.string(from: date)
        return str
    }
    
    @IBAction func doneUIButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "doneWithHistorySegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.didSelected = -1
    }
    
    @IBAction func deleteItem(_ sender: UIBarButtonItem) {
        
        if (self.didSelected == -1){
            let alerts = UIAlertController(title: "Please select an item.", message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            
            alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alerts,animated: true, completion: nil )
        }
        else{
            let alerts = UIAlertController(title: "Are you sure you want to delete : ", message: "\n\(self.getDate(date: self.dates[self.didSelected]))\n\n\n\n\n\n\n", preferredStyle: .alert)
            
            alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(acition) in
                self.dates.remove(at: self.didSelected)
            }))
            self.present(alerts,animated: true, completion: nil )
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.didSelected = indexPath.row
        self.instance.getUser().setCurrentDate(date: self.dates[indexPath.row])
        self.instance.getUser().setItem()
    }
    
    @IBAction func longPressGestureMoreDetail(_ sender: UILongPressGestureRecognizer) {
        performSegue(withIdentifier: "detailFromHistorySegue", sender: nil)
    }
}

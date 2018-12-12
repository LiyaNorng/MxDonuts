//
//  ViewController.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/19/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let instance = Record.instance

    @IBOutlet var backGroundInfo: [UILabel]!
    
    @IBOutlet weak var todayDate: UILabel!
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.instance.getUser().setCurrentDate(date: Date())
        self.setDate()
        self.backGroundInfo[0].text = ("Name: \(self.instance.getUser().getFirstName())  \(self.instance.getUser().getLastName())")
        self.backGroundInfo[1].text = ("Email: \(self.instance.getUser().getEmail())")
        self.setTheLookOnUI()
        
    }
    
    func setTheLookOnUI()->Void{
        for i in 0..<self.buttonCollection.count{
            self.buttonCollection[i].layer.cornerRadius = 4
            self.buttonCollection[i].layer.shadowRadius = 5
            self.buttonCollection[i].layer.shadowOpacity = 1.0
        }
        
    }
    
    func setDate()->Void{
        let format = DateFormatter()
        format.dateFormat = "EEEE, MMMM dd, yyyy HH:mm a"
        let str = format.string(from: self.instance.getUser().getCurrentDate())
        self.todayDate.text = str
    }
    
    
    @IBAction func checkInventory(_ sender: UIButton) {
        
        performSegue(withIdentifier: "inventorySegue", sender: nil)
    }
    
    func getDate(date:Date)->String{
        let format = DateFormatter()
        format.dateFormat = "MMMM,dd,yyyy"
        let str = format.string(from: date )
        return str
    }
    
    @IBAction func deleteAccountUIButton(_ sender: UIButton) {
        
        let alerts = UIAlertController(title: "Are you sure you want to Delete this Account.", message: "\n\n\n\n\n\n\n\\n\n", preferredStyle: .alert)
        
        alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alerts.addAction(UIAlertAction(title: "OK", style: .default, handler: {(acition) in
        
            self.instance.deleteUser()
            self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
        }))
        self.present(alerts,animated: true, completion: nil )
        
    }
    
    @IBAction func loginOutUIButton(_ sender: UIBarButtonItem) {
        self.saveData()
        performSegue(withIdentifier: "backToLoginSegue", sender: nil)
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
    
    @IBAction func userActionUIButton(_ sender: UIButton) {
        
        if (sender.currentTitle == "Supply"){
            
            
            
            if self.instance.getUser().getCurrentInventory().getItemName().isEmpty{
                let alerts = UIAlertController(title: "Please Check the Inventory First", message: "\n\n\n", preferredStyle: .alert)
                
                alerts.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alerts,animated: true, completion: nil )
            }
            else {
                
                
                if (self.instance.getUser().checkForItemForDate(date: self.instance.getUser().getCurrentDate())){
                    
                    let alerts = UIAlertController(title: "You already check your supply for today.", message: "Do you want to look over again?", preferredStyle: .alert)
                    
                    alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alerts.addAction(UIAlertAction(title: "OK", style: .default, handler: {(acition) in
                        self.performSegue(withIdentifier: "checkSupplySegue", sender: nil)
                        
                    }))
                    self.present(alerts,animated: true, completion: nil )
                }
                else {
                    self.performSegue(withIdentifier: "checkSupplySegue", sender: nil)
                }
            }
        }
        else if (sender.currentTitle == "History"){
            performSegue(withIdentifier: "showHistorySegue", sender: nil)
        }
        
    }
}


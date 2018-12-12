//
//  LogIn.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/20/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit

class LogIn: UIViewController, UITextFieldDelegate{
    
    var instance = Record.instance

    var email:String = "dummyValue"
    var password:String = ""
    
    @IBOutlet var buttonSelection: [UIButton]!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        self.errorMessage.text = ""
        self.loadData()
        self.setTheLookOnTheUIButton()
    }
    
    func setTheLookOnTheUIButton()->Void{
        
        for i in 0..<self.buttonSelection.count{
            self.buttonSelection[i].layer.cornerRadius = 4
            self.buttonSelection[i].layer.shadowRadius = 5
            self.buttonSelection[i].layer.shadowOpacity = 1.0
        }
    }
    
    func loadData()->Void{
        do {
            let url = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            
            let path = url.path + "/MxDonuts.data"
            print ("\(path)")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: path) {
                
                let tempModel = NSKeyedUnarchiver.unarchiveObject(withFile: path) as! Record
                print("Load successful")

                Record.instance = tempModel
                self.instance = Record.instance
                print ("got down here")
                
                
            } else {
                print("FILE NOT AVAILABLE")
            }
            
        } catch {
            print ("Something went wrong: \(error)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            self.email = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 1{
            self.password = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 0{
            self.email = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 1{
            self.password = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        textField.resignFirstResponder()
    }
    
    @IBAction func userOptionUIButton(_ sender: UIButton) {

        if (sender.currentTitle == "Sign Up"){
            performSegue(withIdentifier: "signUpSegue", sender: nil)
        }
        else if (sender.currentTitle == "Login"){

            if (self.email != "" && self.password != ""){
                
                if (self.instance.existMember){
                    if (self.email.lowercased() == instance.getUser().getEmail().lowercased() && self.password == instance.getUser().getPassword() && self.email != ""){
                        performSegue(withIdentifier: "loginSegue", sender: nil)
                        
                    }
                    else {
                        self.setError()
                        self.errorMessage.text = "Error, you either input wrong email or password, Try again."
                    }
                }
                else {
                    self.setError()
                    self.errorMessage.text = "Error, Please sign up."
                }
            }
            else {
                self.setError()
                 self.errorMessage.text = "Error, Please fill in the blank."
            }
        }
    }
    
    func setError(){
        self.errorMessage.backgroundColor = UIColor.white
        self.errorMessage.layer.cornerRadius = 4
        self.errorMessage.layer.shadowRadius = 5
        self.errorMessage.layer.shadowOpacity = 1.0
    }
}

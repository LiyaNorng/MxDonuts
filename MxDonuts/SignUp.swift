//
//  SignUp.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/20/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit

class SignUp: UIViewController, UITextFieldDelegate{
    
    var firstName:String = ""
    var lastName:String = ""
    var email1:String = ""
    var email2:String = ""
    var password1:String = ""
    var password2:String = ""
    
    @IBOutlet var buttonSelection: [UIButton]!
    
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        resignFirstResponder()
        self.errorMessage.text = ""
        self.setTheLookOnUIButton()
    }
    
    func setTheLookOnUIButton()->Void{
        for i in 0..<self.buttonSelection.count{
            self.buttonSelection[i].layer.cornerRadius = 4
            self.buttonSelection[i].layer.shadowRadius = 5
            self.buttonSelection[i].layer.shadowOpacity = 1.0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            self.firstName = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 1{
            self.lastName = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 2{
            self.email1 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 3{
            self.email2 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 4{
            self.password1 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 5{
            self.password2 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.tag == 0{
            self.firstName = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 1{
            self.lastName = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 2{
            self.email1 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 3{
            self.email2 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 4{
            self.password1 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        else if textField.tag == 5{
            self.password2 = textField.text!.trimmingCharacters(in: .whitespaces)
        }
        textField.resignFirstResponder()
    }
    
    @IBAction func userOptionUIButton(_ sender: UIButton) {
        
        if (sender.currentTitle == "Cancel"){
            performSegue(withIdentifier: "backToFirstScreenSegue", sender: nil)
        }
        else if (sender.currentTitle == "Sign Up"){
            if (checkForInput()){
                self.addInput()
            }
        }
    }
    
    func checkForInput()->Bool{
        
        if (self.firstName != "" && self.email1 != "" && self.password1 != ""){
            if (self.email1.lowercased() == self.email2.lowercased() && self.password1 == self.password2 && self.email1 != "" && self.password1 != ""){
                return true
            }
            else {
                self.setError()
                self.errorMessage.text = "Error, Email or password not match up."
            }
        }
        else {
            self.setError()
            self.errorMessage.text = "Error, Complete the form."
        }
        
        return false
    }
    
    func addInput()->Void{
        
        let user = User(firstName: self.firstName, lastName: self.lastName, email: self.email1, password: self.password1)
        let instance = Record.instance
        
        if (instance.existMember){
            self.setError()
            self.errorMessage.text = "There is already exist a member in here."
            
        }
        else {
            instance.setUser(user: user)
            instance.existMember = true
            print (instance.getUser().getFirstName())
            self.saveData(instance: instance)
            performSegue(withIdentifier: "backToFirstScreenSegue", sender: nil)
        }
    }
    
    func saveData(instance:Record)->Void{
        do {
            let url = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
            
            let path = url.path + "/MxDonuts.data"
            NSKeyedArchiver.archiveRootObject(instance, toFile: path)
            print ("\(path)")
            
        } catch {
            print ("Something went wrong: \(error)")
        }
    }
    
    func setError()->Void{
        self.errorMessage.backgroundColor = UIColor.white
        self.errorMessage.layer.cornerRadius = 4
        self.errorMessage.layer.shadowRadius = 5
        self.errorMessage.layer.shadowOpacity = 1.0
    }
  
}

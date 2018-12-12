//
//  User.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/19/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import Foundation

class User:NSObject, NSCoding{
    
    private var firstName:String
    private var lastName:String
    private var email:String
    private var password:String
    private var itemWIthKey:[String:Items] = [:]
    private var inventoryItemWithKey:[String:Items] = [:]
    private var date:[Date] = []
    private var item = Items()
    private var currentInventory = Items()
    private var currentDate:Date = Date()
    private var nameListToCheck:[String] = []

    init(firstName:String, lastName:String, email:String, password:String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.itemWIthKey = aDecoder.decodeObject(forKey: "itemWIthKey") as! [String:Items]
        self.inventoryItemWithKey = aDecoder.decodeObject(forKey: "inventoryItemWithKey") as! [String:Items]
        self.date = aDecoder.decodeObject(forKey: "date") as! [Date]
        self.item = aDecoder.decodeObject(forKey: "item") as! Items
        self.nameListToCheck = aDecoder.decodeObject(forKey: "nameListToCheck") as! [String]
        self.currentInventory = aDecoder.decodeObject(forKey: "currentInventory") as! Items
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.itemWIthKey, forKey: "itemWIthKey")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.item, forKey: "item")
        aCoder.encode(self.nameListToCheck,forKey: "nameListToCheck")
        aCoder.encode(self.currentInventory, forKey: "currentInventory")
        aCoder.encode(self.inventoryItemWithKey, forKey: "inventoryItemWithKey")

    }
    
    func getDateToString(date:Date)->String{
        let format = DateFormatter()
        format.dateFormat = "MMMM,dd,yyyy"
        let str = format.string(from: date )
        return str
    }
    
    func getCurrentInventory()->Items{
        return self.currentInventory
    }
    
    
    func getNameListToCheck()->[String]{
        return self.nameListToCheck
    }
    
    func setNameListToCheck(nameListToCheck:[String])->Void{
        self.nameListToCheck = nameListToCheck
    }
    
    func addNameListToCheck(newItemName:String)->Void{
        self.nameListToCheck.append(newItemName)
    }
    
    func addDates()->Void{
        self.date.append(self.currentDate)
    }
   
    func getDates()->[Date]{
        return self.date
    }
    
    func addItemAccordingToDate(){
        self.itemWIthKey[ self.getDateToString(date: self.currentDate)] = self.item
       
    }
    
    func addInventoryItemAccordingToDate(){
        self.inventoryItemWithKey[self.getDateToString(date: self.currentDate)] = self.currentInventory
    }
    
    func setCurrentInventory(){
        self.currentInventory = self.inventoryItemWithKey[self.getDateToString(date: self.currentDate) ]!
    }
    
    func checkForItemForDate(date:Date)->Bool{
        
        if self.itemWIthKey[self.getDateToString(date: date) ] != nil {
            return true
        }
        return false
        
    }
    
    func checkForItemInInventoryItemWithKey(date:Date)->Bool{
        if self.inventoryItemWithKey[self.getDateToString(date: date) ] != nil{
            return true
        }
        return false
        
    }
    
    func removeItemListFromToday(date:Date){
        self.itemWIthKey.removeValue(forKey: self.getDateToString(date: date) )
    }
    
    func setItem(){
        self.item = self.itemWIthKey[self.getDateToString(date: self.currentDate) ]!
    }
    
    func getItems()->Items{
        return self.item
    }
    
    func getCurrentDate()->Date{
        return self.currentDate
    }
    
    func setCurrentDate(date:Date){
        self.currentDate = date
    }
    
    func setFirstName(firstName:String){
        self.firstName = firstName
    }
    
    func setLastName(lastName:String){
        self.lastName = lastName
    }
    
    func setEmail(email:String){
        self.email = email
    }
    
    func setPassword(password:String){
        self.password = password
    }
    
    func getFirstName()->String{
        return self.firstName
    }
    
    func getLastName()->String{
        return self.lastName
    }
    
    func getEmail()->String{
        return self.email
    }
    
    func getPassword()->String{
        return self.password
    }
}

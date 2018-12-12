//
//  Items.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/19/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import Foundation

class Items:NSObject, NSCoding{
    
    private var item:[String]
    private var itemTotal:[String]
    private var itemSize:[String]
    
    override init(){
        
        self.item = []
        self.itemTotal = []
        self.itemSize = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = aDecoder.decodeObject(forKey: "item") as! [String]
        self.itemTotal = aDecoder.decodeObject(forKey: "itemTotal") as! [String]
        self.itemSize = aDecoder.decodeObject(forKey: "itemSize") as! [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.item, forKey: "item")
        aCoder.encode(self.itemTotal, forKey: "itemTotal")
        aCoder.encode(self.itemSize, forKey: "itemSize")
    }
    
    func setItemSize(itemSize:[String])->Void{
        self.itemSize = itemSize
    }
    
    func getItemSize()->[String]{
        return self.itemSize
    }
    
    func setItemName(item:[String])->Void{
        self.item = item
    }
    
    func setItemTotal(itemTotal:[String])->Void{
        self.itemTotal = itemTotal
    }
    
    func getItemName()->[String]{
        return self.item
    }
    
    func getItemTotal()->[String]{
        return self.itemTotal
    }
}

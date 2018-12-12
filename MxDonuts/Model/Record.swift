//
//  Record.swift
//  MxDonuts
//
//  Created by Liya Norng on 9/20/18.
//  Copyright © 2018 LiyaNorng. All rights reserved.
//

import UIKit


class Record:NSObject, NSCoding{
    
    var user:User?
    static var instance:Record = Record()
    var successful:Bool = false
    var existMember:Bool = false

    override init() {
        
    }
    
    required init(coder aDecoder:NSCoder) {
        self.user = aDecoder.decodeObject(forKey: "user") as? User
        self.existMember = aDecoder.decodeBool(forKey: "existMember") as Bool
        
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.existMember, forKey: "existMember")
    }
    
    func getUser()->User{
        return self.user!
    }
    
    func setUser(user:User)->Void{
        self.user = user
    }
    
    func deleteUser()->Void{
        let newUser = User(firstName: "", lastName: "", email: "", password: "")
        self.user = newUser
        self.existMember = false
        self.successful = false
    }
    
}

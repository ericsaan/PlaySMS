//
//  Settings.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 8/3/18.
//  Copyright © 2018 Sully. All rights reserved.
//

import Foundation
class Settings
{
    
    var contactOne: String? = ""
    var contactOnePhoneNumber: String? = ""
    var contactTwo: String? = ""
    var contactTwoPhoneNumber: String? = ""
    var appUserName: String? = ""
    var appUserPhoneNumber: String? = ""
    var busRoute1: String? = ""
    var busRoute2: String? = ""
    var busRoute3: String? = ""
    var switchConfetti: String? = "1"
    
    func refreshSettings() {
        contactOne = UserDefaults.standard.value(forKey: "ContactOneName") as! String?
        contactOnePhoneNumber = UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String?
        contactTwo = UserDefaults.standard.value(forKey: "ContactTwoName") as! String?
        contactTwoPhoneNumber = UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String?
        appUserName = UserDefaults.standard.value(forKey: "AppUserName") as! String?
        appUserPhoneNumber = UserDefaults.standard.value(forKey: "AppUserPhoneNumber") as! String? 
        busRoute1 = UserDefaults.standard.value(forKey: "BusRoute1") as? String  ?? "000"
        busRoute2 = UserDefaults.standard.value(forKey: "BusRoute2") as? String  ?? "000"
        busRoute3 = UserDefaults.standard.value(forKey: "BusRoute3") as? String  ?? "000"
        switchConfetti = UserDefaults.standard.value(forKey: "SwitchConfetti") as? String ?? "1"
        
    }
    
    
    
}

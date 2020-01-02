//
//  Settings.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 8/3/18.
//  Copyright © 2018 Sully. All rights reserved.
//

import Foundation
import UIKit
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
    var skinLogo: String? = ""
    var skinEvergreen = "EvergreenWhiteLogo.png"
    var skinLakeside = "LakesideLogo.png"
    var skinUniversityPrep = "University Prep Logo.jpg"
    var skinNeutral = "cartoon-school-bus-clipart-17.jpg"
    
    let swiftColorLakeside = UIColor(red: 104.0/255.0, green: 5.0/255.0, blue: 0.0, alpha: 1)
    let swiftColorEvergreen = UIColor(red: 43.0/255.0, green: 119.0/255.0, blue: 101.0/255.0, alpha: 1)
    
    let swiftColorUniversityPrep = UIColor(red: 37.0/255.0, green: 91.0/255.0, blue: 137.0/255.0, alpha: 1)
    
    let swiftColorNeutral = UIColor.white
    
    
    let skins = ["Lakeside", "Evergreen", "University Prep", "Neutral"]
    
    let skinLogos = ["LakesideLogo.png","EvergreenWhiteLogo.png","University Prep Logo.jpg", "cartoon-school-bus-clipart-17.jpg"]
    
    func refreshSettings() {
        contactOne = UserDefaults.standard.value(forKey: "ContactOneName") as! String?
        contactOnePhoneNumber = UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String?
        contactTwo = UserDefaults.standard.value(forKey: "ContactTwoName") as! String?
        contactTwoPhoneNumber = UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String?
        appUserName = UserDefaults.standard.value(forKey: "AppUserName") as! String? ?? "Sully"
        appUserPhoneNumber = UserDefaults.standard.value(forKey: "AppUserPhoneNumber") as! String? 
        busRoute1 = UserDefaults.standard.value(forKey: "BusRoute1") as? String  ?? "986"
        busRoute2 = UserDefaults.standard.value(forKey: "BusRoute2") as? String  ?? "989"
        busRoute3 = UserDefaults.standard.value(forKey: "BusRoute3") as? String  ?? "981"
        switchConfetti = UserDefaults.standard.value(forKey: "SwitchConfetti") as? String ?? "1"
        skinLogo = UserDefaults.standard.value(forKey: "SkinLogo") as? String ?? "Lakeside"
        
    }
    
    
    
}

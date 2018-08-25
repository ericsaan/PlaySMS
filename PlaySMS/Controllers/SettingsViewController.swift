//
//  SettingsViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/14/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class SettingsViewController: UIViewController, MFMessageComposeViewControllerDelegate
{

    var settingsData: Settings = Settings()
    
    @IBOutlet weak var txtContactOneNameSize: UITextField!
    
    @IBOutlet weak var c1PhoneNumber: UITextField!
    
    
    @IBOutlet weak var c2Name: UITextField!
    
    @IBOutlet weak var c2PhoneNumber: UITextField!
    @IBOutlet weak var studentName: UITextField!
    @IBOutlet weak var studentPhoneNumber: UITextField!
    @IBOutlet weak var bRoute1: UITextField!
    @IBOutlet weak var bRoute2: UITextField!
    @IBOutlet weak var bRoute3: UITextField!
    
    
    
    @IBOutlet weak var lblSettings: UILabel!
    
    @IBOutlet weak var butSave: UIButton!
    
    @IBOutlet weak var butTransportation: UIButton!
    
    @IBOutlet weak var lblAcks: UILabel!
    
    @IBOutlet weak var lblVersions: UILabel!
    @IBOutlet weak var butIcons: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    
    
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {

        settingsData.refreshSettings()
        
        txtContactOneName.text = settingsData.contactOne
        txtContactOnePhoneNumber.text = settingsData.contactOnePhoneNumber
        txtContactTwoName.text = settingsData.contactTwo
        txtContactTwoPhoneNumber.text = settingsData.contactTwoPhoneNumber
        txtAppUserPhone.text = settingsData.appUserPhoneNumber
        
        txtAppUserName.text = settingsData.appUserName
        txtBusRoute1.text = settingsData.busRoute1
        txtBusRoute2.text = settingsData.busRoute2
        txtBusRoute3.text = settingsData.busRoute3
        if settingsData.switchConfetti == "1" {
            switchConfetti.setOn(true, animated: true)
            
        } else {
            switchConfetti.setOn(false, animated: true)
        }
        //now to center all the buttons for whatever size screen we have
        settingsLayout()
    }
   //************************************************
    func settingsLayout() {
        let screenWidth = Int(self.view.frame.width)
        let iPhoneVer: IPhoneVersion = IPhoneVersion()
        
        butSave.center.x = self.view.center.x
        butTransportation.center.x = self.view.center.x
        butIcons.center.x = self.view.center.x
        lblSettings.center.x = self.view.center.x
        lblAcks.center.x = self.view.center.x
        lblVersions.center.x = self.view.center.x
        
        switch screenWidth {
        case iPhoneVer.iPhone6PlusWidth, iPhoneVer.iPhone6sPlusWidth, iPhoneVer.iPhone7PlusWidth, iPhoneVer.iPhone8PlusWidth:
            
            txtContactOneNameSize.frame.size.width = 225
            c1PhoneNumber.frame.size.width = 225
            c2Name.frame.size.width = 225
            c2PhoneNumber.frame.size.width = 225
            studentName.frame.size.width = 225
            studentPhoneNumber.frame.size.width = 225
            bRoute1.frame.size.width = 225
            bRoute2.frame.size.width = 225
            bRoute3.frame.size.width = 225
            
        default:
            return
            
        }
        
        self.view.layoutIfNeeded()
    }
    
    
    
    
    
 
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    //***************************************************************
    //now we define variables for all the text fields
    //***************************************************************
    
    @IBOutlet weak var txtContactOneName: UITextField!
    
    @IBOutlet weak var txtContactOnePhoneNumber: UITextField!
    
    
    @IBOutlet weak var txtContactTwoName: UITextField!
    
    
    @IBOutlet weak var txtContactTwoPhoneNumber: UITextField!
    
    @IBOutlet weak var txtAppUserName: UITextField!
    
    @IBOutlet weak var txtAppUserPhone: UITextField!
    
    @IBOutlet weak var txtBusRoute1: UITextField!
    
    @IBOutlet weak var txtBusRoute2: UITextField!
    
    @IBOutlet weak var txtBusRoute3: UITextField!
    
    @IBOutlet weak var switchConfetti: UISwitch!
    
    
    
    //***************************************************************
    //now we start with the actions from buttons on the board
    //***************************************************************
    
    
    @IBAction func btnLakesideTransportation(_ sender: UIButton)
    {
        let icon8URL = NSURL(string: "http://www.lakesideschool.org/about-us/transportation")
        UIApplication.shared.open(icon8URL! as URL, options: [:], completionHandler: nil)
        
        
    }
    
    
    

    @IBAction func btnIcon8(_ sender: UIButton)
    {
        
            let icon8URL = NSURL(string: "http://icons8.com")
        UIApplication.shared.open(icon8URL! as URL, options: [:], completionHandler: nil)
    }

    
    @IBAction func btnMoonspec(_ sender: UIButton)
    {
        let MoonspecURL = NSURL(string: "http://moonspec.com")
        UIApplication.shared.open(MoonspecURL! as URL, options: [:], completionHandler: nil)
        
    }

    
    @IBAction func txtStudentPhone(_ sender: UITextField) {
    }
    

    @IBAction func txtContactTwoPhone(_ sender: UITextField) {
    }
    
    
    @IBAction func txtContactTwoName(_ sender: UITextField)
    {
        
        var inSender = sender.text!
        if inSender.characters.count > 12
        {
            let index = inSender.index(inSender.startIndex, offsetBy: 12)
            txtContactTwoName.text = inSender.substring(to: index)  // Hello
        }
    }
        
    
    @IBAction func txtContactOnePhone(_ sender: UITextField) {
    }
    
    
    @IBAction func txtContactOneName(_ sender: UITextField)
    {
        var inSender = sender.text!
        if inSender.characters.count > 12
        {
            let index = inSender.index(inSender.startIndex, offsetBy: 12)
            txtContactOneName.text = inSender.substring(to: index)
        }
    }
    
    
    @IBAction func btnSubmit(_ sender: UIButton)
    {
        let savedContactOneName = txtContactOneName.text!
        let savedContactOnePhoneNumber = txtContactOnePhoneNumber.text!
        let savedContactTwoName = txtContactTwoName.text!
        let savedContactTwoPhoneNumber = txtContactTwoPhoneNumber.text!
        let savedAppUserName = txtAppUserName.text!
        let savedAppUserPhoneNumber = txtAppUserPhone.text!
        let savedBusRoute1 = txtBusRoute1.text!
        let savedBusRoute2 = txtBusRoute2.text!
        let savedBusRoute3 = txtBusRoute3.text!
        
        var switchState: String = "1"
        if !switchConfetti.isOn {
         switchState = "0"
        }
        let savedSwitchConfetti = switchState
        
        
        
        
        UserDefaults.standard.set(savedContactOneName, forKey: "ContactOneName")
        UserDefaults.standard.set(savedContactOnePhoneNumber, forKey: "ContactOnePhoneNumber")
        UserDefaults.standard.set(savedContactTwoName, forKey: "ContactTwoName")
        UserDefaults.standard.set(savedContactTwoPhoneNumber, forKey: "ContactTwoPhoneNumber")
        UserDefaults.standard.set(savedAppUserName, forKey: "AppUserName")
        UserDefaults.standard.set(savedAppUserPhoneNumber, forKey: "AppUserPhoneNumber")
        UserDefaults.standard.set(savedBusRoute1, forKey: "BusRoute1")
        UserDefaults.standard.set(savedBusRoute2, forKey: "BusRoute2")
        UserDefaults.standard.set(savedBusRoute3, forKey: "BusRoute3")
        UserDefaults.standard.set(savedSwitchConfetti, forKey: "SwitchConfetti")
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}

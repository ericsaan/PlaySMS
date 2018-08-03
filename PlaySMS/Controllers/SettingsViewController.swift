//
//  SettingsViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/14/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMessageComposeViewControllerDelegate
{

    
    
    
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

        txtContactOneName.text = UserDefaults.standard.value(forKey: "ContactOneName") as! String?
        txtContactOnePhoneNumber.text = UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String?
        txtContactTwoName.text = UserDefaults.standard.value(forKey: "ContactTwoName") as! String?
        txtContactTwoPhoneNumber.text = UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String?
        txtAppUserPhone.text = UserDefaults.standard.value(forKey: "AppUserPhoneNumber") as! String?
        
        txtAppUserName.text = UserDefaults.standard.value(forKey: "AppUserName") as! String?
        txtBusRoute1.text = UserDefaults.standard.value(forKey: "BusRoute1") as! String? ?? "007"
        txtBusRoute2.text = UserDefaults.standard.value(forKey: "BusRoute2") as! String? ?? "008"
        txtBusRoute3.text = UserDefaults.standard.value(forKey: "BusRoute3") as! String? ?? "009"
        
        
        
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
    //@IBOutlet weak var txtStudentPhoneNumber: UITextField!
    
    @IBOutlet weak var txtAppUserPhone: UITextField!
    
    @IBOutlet weak var txtBusRoute1: UITextField!
    
    @IBOutlet weak var txtBusRoute2: UITextField!
    
    @IBOutlet weak var txtBusRoute3: UITextField!
    
    
    
    
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
   /*
    var url = ""
        url="www.icon8.com"  // Load URLs into here
        self.openUrl(url: url);
    */
        
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
        
        
        
        UserDefaults.standard.set(savedContactOneName, forKey: "ContactOneName")
        UserDefaults.standard.set(savedContactOnePhoneNumber, forKey: "ContactOnePhoneNumber")
        UserDefaults.standard.set(savedContactTwoName, forKey: "ContactTwoName")
        UserDefaults.standard.set(savedContactTwoPhoneNumber, forKey: "ContactTwoPhoneNumber")
        UserDefaults.standard.set(savedAppUserName, forKey: "AppUserName")
        UserDefaults.standard.set(savedAppUserPhoneNumber, forKey: "AppUserPhone")
        UserDefaults.standard.set(savedBusRoute1, forKey: "BusRoute1")
        UserDefaults.standard.set(savedBusRoute2, forKey: "BusRoute2")
        UserDefaults.standard.set(savedBusRoute3, forKey: "BusRoute3")
        
    }
    
    
    
    
    
    
    
    
}

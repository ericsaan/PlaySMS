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
import GoogleSignIn

class SettingsViewController: UIViewController, MFMessageComposeViewControllerDelegate, GIDSignInUIDelegate
{

    
    @IBOutlet var viewMain: UIView!
    var settingsData: Settings = Settings()
    
    @IBOutlet weak var lbl1stContact: UILabel!
    
    @IBOutlet weak var lbl1stContactPhone: UILabel!
    
    
    @IBOutlet weak var lbl2ndContact: UILabel!
    @IBOutlet weak var lbl2ndContactPhone: UILabel!
    
    @IBOutlet weak var lblAppUser: UILabel!
    
    
    @IBOutlet weak var lblAppUserPhone: UILabel!
    
    @IBOutlet weak var lblBusRoute1: UILabel!
    @IBOutlet weak var lblBusRoute2: UILabel!
    
    @IBOutlet weak var lblBusRoute3: UILabel!
    
    @IBOutlet weak var lblConfettiPop: UILabel!
    
    
    @IBOutlet weak var lblSignInOut: UILabel!
    @IBOutlet weak var lblSettings2: UILabel!
    @IBOutlet weak var btnGoogleSignInOut: UIButton!
    
    @IBOutlet weak var lblMoonSpec: UILabel!
    @IBOutlet weak var lblKatya: UILabel!
    @IBOutlet weak var imageGoogle: UIImageView!
    @IBOutlet weak var txtContactOneNameSize: UITextField!
    
    @IBOutlet weak var c1PhoneNumber: UITextField!
    
    
    @IBOutlet weak var c2Name: UITextField!
    
    @IBOutlet weak var c2PhoneNumber: UITextField!
    @IBOutlet weak var studentName: UITextField!
    @IBOutlet weak var studentPhoneNumber: UITextField!
    @IBOutlet weak var bRoute1: UITextField!
    @IBOutlet weak var bRoute2: UITextField!
    @IBOutlet weak var bRoute3: UITextField!
    
    
    @IBOutlet weak var btnIcons: UIButton!
    
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
        
      
        
        
        settingsLayout()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
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
        setBackgrounds()
        settingsLayout()
    }
   //************************************************
    @objc func settingsLayout() {
        let screenWidth = Int(self.view.frame.width)
        let iPhoneVer: IPhoneVersion = IPhoneVersion()
        
        butSave.center.x = self.view.center.x
        //butTransportation.center.x = self.view.center.x
        butIcons.center.x = self.view.center.x
        lblSettings2.center.x = self.view.center.x
        lblAcks.center.x = self.view.center.x
        lblVersions.center.x = self.view.center.x
        lblKatya.center.x = self.view.center.x
        lblMoonSpec.center.x = self.view.center.x
        lblSignInOut.center.x = CGFloat(screenWidth - 50)
        btnGoogleSignInOut.center.x = CGFloat(screenWidth - 50)
        
        
        self.view.layoutIfNeeded()
       
        
        switch screenWidth {
        case iPhoneVer.iPhone6PlusWidth, iPhoneVer.iPhone6sPlusWidth, iPhoneVer.iPhone7PlusWidth, iPhoneVer.iPhone8PlusWidth, iPhoneVer.iPhoneXWidth,iPhoneVer.iPhone8Width:
            
            txtContactOneNameSize.frame.size.width = 242
            c1PhoneNumber.frame.size.width = 242
            c2Name.frame.size.width = 242
            c2PhoneNumber.frame.size.width = 242
            studentName.frame.size.width = 242
            studentPhoneNumber.frame.size.width = 242
            bRoute1.frame.size.width = 242
            bRoute2.frame.size.width = 242
            bRoute3.frame.size.width = 242
            
             self.view.layoutIfNeeded()
           
        case iPhoneVer.iPhone5Width, iPhoneVer.iPhone4Width, iPhoneVer.iPhone3Width:
            
            
            self.view.layoutIfNeeded()
            
            
            
        default:
            return
            
        }
        
       
    }
    
    
    @IBAction func buttonSignInOut(_ sender: Any) {
       
        if Auth.auth().currentUser != nil
        {
            btnGoogleSignInOut.setTitle("Sign In", for: .normal)
            do {
                let currentUser = Auth.auth().currentUser?.email
                
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
                print ("Sign out successful")
                
                //now to signout of google itself.
                GIDSignIn.sharedInstance().signOut()
                //now delete record/document from userDB
                //firest we reset the student user email and update the text field
                UserDefaults.standard.set("", forKey: "AppUserName")
                settingsData.refreshSettings()
                txtAppUserName.text = settingsData.appUserName
                
                
                //now to update the ExtendedUserDB with the fcmToken from this device for the logged in email
                let userDB = Firestore.firestore()
                let settings = userDB.settings
                settings.areTimestampsInSnapshotsEnabled = true
                userDB.settings = settings
                
                let deviceTokenIn = AppDelegate.GlobalVariable.deviceTokenGlobal
                
                userDB.collection("userFcmtokens")
                    
                    .whereField("email", isEqualTo: currentUser!)
                    .whereField("fcmToken", isEqualTo: deviceTokenIn)   
                    .getDocuments() { (querySnapshot, err) in
                        
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            if querySnapshot?.count == 0 {
                                //fcmtoken is not present for this user so nothing to delete
                                return
                            }  //end query snapshot == nil
                            
                            //now we have a match and just to make sure we will delete each one that matches
                            for document in querySnapshot!.documents {
                                print("Deleting: \(document.documentID) => \(document.data())")
                                userDB.collection("userFcmtokens").document(document.documentID).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                    }
                                }
                            }
                        }
                        
                }
                
            } catch let err {
                print(err)
            }
        } else{
             btnGoogleSignInOut.setTitle("Sign Out", for: .normal)
            GIDSignIn.sharedInstance().signIn()
             settingsData.refreshSettings()
            txtAppUserName.text = settingsData.appUserName
              self.view.layoutIfNeeded()
            
            
        }
       }  //endbuttongsigninoutfunction
    
    
 
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
        
    }
        
    
    @IBAction func txtContactOnePhone(_ sender: UITextField) {
    }
    
    
    @IBAction func txtContactOneName(_ sender: UITextField)
    {
    }
    
    
    @IBAction func btnSubmit(_ sender: UIButton)
    {
        let savedContactOneName = txtContactOneName.text!
        let savedContactOnePhoneNumber = txtContactOnePhoneNumber.text!
        let savedContactTwoName = txtContactTwoName.text!
        let savedContactTwoPhoneNumber = txtContactTwoPhoneNumber.text!
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
        UserDefaults.standard.set(savedAppUserPhoneNumber, forKey: "AppUserPhoneNumber")
        UserDefaults.standard.set(savedBusRoute1, forKey: "BusRoute1")
        UserDefaults.standard.set(savedBusRoute2, forKey: "BusRoute2")
        UserDefaults.standard.set(savedBusRoute3, forKey: "BusRoute3")
        UserDefaults.standard.set(savedSwitchConfetti, forKey: "SwitchConfetti")
        
        
    }
    
    
    
    func setBackgrounds() {
        
        switch settingsData.skinLogo {
        case "Evergreen":
            self.view.backgroundColor = settingsData.swiftColorEvergreen
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorEvergreen
            setLabelColor(colorIn: UIColor.white)
            
        case "University Prep":
            self.view.backgroundColor = settingsData.swiftColorUniversityPrep
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorUniversityPrep
            setLabelColor(colorIn: UIColor.white)
            
        case "Neutral":
            
            self.view.backgroundColor = settingsData.swiftColorNeutral
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorNeutral
            
            
            setLabelColor(colorIn: UIColor.black)
            
            
            
        default:  //as in Lakeside
            
            self.view.backgroundColor = settingsData.swiftColorLakeside
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorLakeside
            setLabelColor(colorIn: UIColor.white)
            
        }  //endswitch
        self.view.layoutIfNeeded()
    }  //endsetbackground
    
    func setLabelColor(colorIn: UIColor) {
        
        lblSettings2.textColor = colorIn
        
        lbl1stContact.textColor = colorIn
        lbl1stContactPhone.textColor = colorIn
        lbl2ndContact.textColor = colorIn
        lbl2ndContactPhone.textColor = colorIn
        lblAppUser.textColor = colorIn
        lblAppUserPhone.textColor = colorIn
        lblBusRoute1.textColor = colorIn
        lblBusRoute2.textColor = colorIn
        lblBusRoute3.textColor = colorIn
        lblAcks.textColor = colorIn
        lblVersions.textColor = colorIn
        butIcons.setTitleColor(colorIn, for: .normal)
        lblKatya.textColor = colorIn
        lblMoonSpec.textColor = colorIn
        lblVersions.textColor = colorIn
        lblSignInOut.textColor = colorIn
    }
    
}

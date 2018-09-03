//
//  ViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 12/31/16.
//  Copyright © 2016 Sully. All rights reserved.
//

import UIKit
import MessageUI
import Cheers
import Firebase
import GoogleSignIn





class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, GIDSignInUIDelegate
{
    
    
    @objc let cheerView = CheerView()
    @objc var recipientsList = [String]()
    @objc var statusMessageToSend = ""
    @objc var parentOne: String? = ""
    @objc var parentTwo: String? = ""
    @objc var appUserName: String? = ""
    @objc var busRoute1: String? = ""
    @objc var busRoute2: String? = ""
    @objc var busRoute3: String? = ""
    @objc var switchConfetti: String? = "1"
    
    var settingsData: Settings = Settings()
    
    @IBOutlet weak var imgLakeside: UIImageView!
    @IBOutlet weak var lblOnTheBus: UILabel!
    @IBOutlet weak var butRoute1: UIButton!
    @IBOutlet weak var butRoute2: UIButton!
    @IBOutlet weak var butRoute3: UIButton!
    
    //************************************************************************
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
       
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
            
            if switchConfetti == "1" {
                popConfetti()
            }
        }
        
    }
    //************************************************************************
    
    @IBAction func btn2Pressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
        
            if switchConfetti == "1" {
                popConfetti()
            }
        }
    }
    //************************************************************************
    
    @IBAction func btn3Pressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
            
            if switchConfetti == "1" {
                popConfetti()
            }
        }
    }
    //************************************************************************
    
    @IBAction func btnImhere(_ sender: UIButton)
    {
        let statusMessageToSend = "I'm Here!                                                    "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        let sendStatus = sendMessageToDatabase(messageToSend: statusMessageToSend)
        
    }
    
    //************************************************************************
    
    @IBAction func btnPickedUp(_ sender: UIButton)
    {
        let statusMessageToSend = "Picked Up!                                                   "
        
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        let sendStatus = sendMessageToDatabase(messageToSend: statusMessageToSend)
        
    }
        
    //************************************************************************
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cheerView.frame = view.bounds
    }
    
    
    //****************************************************
    //need to refactor to get better encapsulation...ees
    //****************************************************
    @objc func sendMessageToDatabase(messageToSend : String) -> Bool
    {
        
        if Auth.auth().currentUser == nil {
            //call login for google
           //alert sign in on the settings page then segue
            let alert = UIAlertController(title: "Login Alert", message: "You need to login...", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alert.addAction(defaultAction)
            present(alert, animated: true)
            return false
          
        } else {
        
            let messagesDB = Database.database().reference().child("Messages")
            
            //first let's get the list of recipients
            recipientsList.removeAll()
            settingsData.refreshSettings()
            parentOne = settingsData.contactOne
            parentTwo = settingsData.contactTwo
            switchConfetti = settingsData.switchConfetti
            
            let messageToSendOut = messageToSend.padding(toLength: 64, withPad: " ", startingAt: 0)
            
            if  parentOne != nil && parentOne != ""
            {
                recipientsList.append(parentOne!)
               // print (parentOne!)
            }
            
          
            if parentTwo != nil && parentTwo != ""
            {
                recipientsList.append(parentTwo!)
                //print (parentTwo!)
            }

             appUserName = settingsData.appUserName
             if appUserName == nil{
                appUserName = "No App User Specified"
            }
            
            if recipientsList.count != 0
            {
                for i in 0 ... recipientsList.count - 1
                {
                    let dateString = getDateString()
                    let messageDictionary = ["Receiver": recipientsList[i],
                        "MessageBody": messageToSendOut, "Sender": appUserName as Any, "DateString": dateString as Any]
                
                messagesDB.childByAutoId().setValue(messageDictionary){
                    (error, reference) in
                    
                    if error != nil{
                        print(error!)
                    }else {
                        print ("message saved successfully")
                       
                    }
                  }
                } //endforloop
            } //endif loop
        }//end if on user = nil
        
        return true
    }
    
    //************************************************************************
    
    @objc func sendSMStatusUpdate (messageToSend : String)
    {

        //first let's get the list of recipients
        recipientsList.removeAll()
        parentOne = settingsData.contactOnePhoneNumber
        parentTwo = settingsData.contactTwoPhoneNumber
            
            if  parentOne != ""
            {
                recipientsList.append(parentOne!)
                //print (parentOne!)
            }
       
            if parentTwo != ""
            {
                recipientsList.append(parentTwo!)
               // print (parentTwo!)
            }
    
        let messageVC = MFMessageComposeViewController()
        messageVC.body =   messageToSend
        messageVC.recipients = recipientsList;
        messageVC.messageComposeDelegate = self;
        
        //make sure we check for nil here or simulator
        if (MFMessageComposeViewController.canSendText()) {
            self.present(messageVC, animated: false, completion: nil)
            
            }
        
    }
    
    //************************************************************************
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
   
    //************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        view.addSubview(cheerView)

        //call login for google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }

    //************************************************************************
    
    override func viewWillAppear(_ animated: Bool)
    {
        //get all the user defaults and assign to variables
        settingsData.refreshSettings()
        parentOne = settingsData.contactOne
        parentTwo = settingsData.contactTwo
        appUserName = settingsData.appUserName
        busRoute1 = settingsData.busRoute1
        busRoute2 = settingsData.busRoute2
        busRoute3 = settingsData.busRoute3
        switchConfetti = settingsData.switchConfetti
        
        //set the titles of the 3 primary buttons
        butRoute1.setTitle(busRoute1, for: .normal)
        butRoute2.setTitle(busRoute2, for: .normal)
        butRoute3.setTitle(busRoute3, for: .normal)
        mainSettingsLayout()
        
    }
    
    //*******************************************
    @objc func mainSettingsLayout() {
        let screenWidth = Int(self.view.frame.width)
        let iPhoneVer: IPhoneVersion = IPhoneVersion()
        let r1BallX = self.view.center.x - 134
        let r2BallX = self.view.center.x-1
        let ballSize: CGFloat = 134
        
        
        imgLakeside.center.x = self.view.center.x
        lblOnTheBus.center.x = self.view.center.x
        
        switch screenWidth {
        case iPhoneVer.iPhone6PlusWidth, iPhoneVer.iPhone6sPlusWidth, iPhoneVer.iPhone7PlusWidth, iPhoneVer.iPhone8PlusWidth:
            
            butRoute1.frame.size.width = ballSize
            butRoute1.frame.size.height = ballSize
            butRoute1.frame.origin.x = r1BallX
            
            butRoute2.frame.size.width = ballSize
            butRoute2.frame.size.height = ballSize
            butRoute2.frame.origin.x = r2BallX
            
            butRoute3.frame.size.width = ballSize
            butRoute3.frame.size.height = ballSize
            butRoute3.center.x = self.view.center.x
            butRoute3.frame.origin.y = butRoute1.frame.origin.y + 112
            
        default:
            return
            
        }
        self.view.layoutIfNeeded()
        
    }
    
    //******************************************
    @objc func MorningOrAfternoon() -> String
    {
        var timeOfDay = ""
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if (hour < 12)
        {
            timeOfDay = "Morning"
        }
        else if (hour < 17)
        {
            timeOfDay = "Afternoon"
        }
        else
        {
            timeOfDay = "Evening Activity"
        }
        return (timeOfDay)
    }
    
    //******************************************
    @objc func popConfetti() {
     
        cheerView.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
        self.cheerView.stop()
        }
     } //  endpopconfetti
    
    //******************************************
        
    @objc func getDateString() -> String {
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .short
       
        let dateString = formatter.string(from: date)
       
        return dateString
    }
    
    
}


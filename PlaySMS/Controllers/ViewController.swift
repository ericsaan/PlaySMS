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




class ViewController: UIViewController, MFMessageComposeViewControllerDelegate
{
    
    
    let cheerView = CheerView()
    var recipientsList = [String]()
    
    var statusMessageToSend = ""
    
   
    var parentOne: String? = ""
    var parentTwo: String? = ""
    var studentName: String? = ""
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. -"
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        studentName = studentName! + ": "
        studentName = studentName! + String(hour) + ":" + String(minute)
        
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        sendMessageToDatabase(messageToSend: statusMessageToSend + " " + studentName! )
        popConfetti()
        
    }
    
    @IBAction func btn2Pressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. -"
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        sendMessageToDatabase(messageToSend: statusMessageToSend)
        
        popConfetti()
    }
    
    @IBAction func btn3Pressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. -"
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        sendMessageToDatabase(messageToSend: statusMessageToSend)
        
        popConfetti()
    }
    
    @IBAction func btnImhere(_ sender: UIButton)
    {
        let statusMessageToSend = "I'm Here! "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        sendMessageToDatabase(messageToSend: statusMessageToSend)
        
    }
    
    
    @IBAction func btnPickedUp(_ sender: UIButton)
    {
        let statusMessageToSend = "Picked Up! "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        sendMessageToDatabase(messageToSend: statusMessageToSend)
        
    }
        
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cheerView.frame = view.bounds
    }
    
    
    
    
    //****************************************************
    //need to refactor to get better encapsulation...ees
    //****************************************************
    func sendMessageToDatabase(messageToSend : String)
    {
        let messagesDB = Database.database().reference().child("Messages")
        
        //first let's get the list of recipients
        recipientsList.removeAll()
        
        //parentOne = (UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String?)!
        
        
        if  parentOne != ""
        {
            recipientsList.append(parentOne!)
            print (parentOne!)
        }
        
       // parentTwo = (UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String?)!

        if parentTwo != ""
        {
            recipientsList.append(parentTwo!)
            print (parentTwo!)
        }

        
        if recipientsList.count != 0
        {
            for i in 0 ... recipientsList.count - 1
            {
            
            let messageDictionary = ["Receiver": recipientsList[i], //Auth.auth().currentUser?.email,
                "MessageBody": messageToSend]
            
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
        
    }
    
    
    
    func sendSMStatusUpdate (messageToSend : String)
    {

        //first let's get the list of recipients
        recipientsList.removeAll()
        
       //parentOne = (UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String?)!
       
            
            if  parentOne != ""
            {
                recipientsList.append(parentOne!)
                print (parentOne!)
            }
       
        
        
           // parentTwo = (UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String?)!
            
            if parentTwo != ""
            {
                recipientsList.append(parentTwo!)
                print (parentTwo!)
            }
    

        let messageVC = MFMessageComposeViewController()
        
        messageVC.body =   messageToSend
        

        // MessageVC.recipients = ["4252411879"];
        messageVC.recipients = recipientsList;
        messageVC.messageComposeDelegate = self;
        
        //make sure we check for nil here or simulator
        if (MFMessageComposeViewController.canSendText()) {
            self.present(messageVC, animated: false, completion: nil)
            
            }
        
        
        
        
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        let parentOne = UserDefaults.standard.value(forKey: "ParentOne") as? String ?? String()
//        let parentTwo = UserDefaults.standard.value(forKey: "ParentTwo") as? String ?? String()
        parentOne = UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String?
        if parentOne == nil {
            parentOne = "No Parent One"
        }
        parentTwo = UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String?
        if parentTwo == nil {
            parentTwo = "No Parent Two"
        }
        
        studentName = UserDefaults.standard.value(forKey: "StudentName") as? String
        if studentName == nil{
            studentName = "No Student Specified"
        }
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        view.addSubview(cheerView)

        
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
       //NOTHING HERE, USED TO BE WHERE WE UPDATED THE LABELS WITH PARENT/GUARDIAN
    }
    
    
    
    //******************************************
    func MorningOrAfternoon() -> String
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
    func popConfetti() {
     
        cheerView.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
        self.cheerView.stop()
        }
     } //  endpopconfetti
    //******************************************
        
        
        
        
}


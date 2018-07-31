//
//  ViewController_Conversations.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/8/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit
import MessageUI

class ViewController_Conversations: UIViewController, MFMessageComposeViewControllerDelegate
{

    
    var recipientsList = [String]()
    
   
    var statusMessageToSend = ""
    
    var studentPhoneNumber  = ""
    
    //now all the button action methods
    
    
  
    
    
    //*****************************************************
    //btn action to open onebusaway or waze
    //*****************************************************
    
//    @IBAction func btnWhereIsBus(_ sender: UIButton)
//    {
//        //let findMyFriendsHooks = "onebusaway.co://"
//        //let findMyFriendsHooks = "waze://?ll=47.6205,122.3493"
//        //let findMyFriendsHooks = "waze://?ll=37.44469,-122.15971&z=10"
//
//        let findMyFriendsHooks = "onebusaway://"
//
//        let appUrl = URL(string: findMyFriendsHooks)
//        if UIApplication.shared.canOpenURL(appUrl! as URL)
//        {
//            UIApplication.shared.open(appUrl!)
//
//        } else {
//            //redirect to safari because the user doesn't have Instagram
//            print("App not installed")
//            UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/onebusaway/id329380089?mt=8")!)
//        //UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
//        }
//
//    }
//
//    @IBAction func btnWhereRU(_ sender: UIButton)
//    {
//
//        let findMyFriendsHooks = "findmyfriends://"
//
//        let appUrl = URL(string: findMyFriendsHooks)
//        if UIApplication.shared.canOpenURL(appUrl! as URL)
//        {
//            UIApplication.shared.open(appUrl!)
//
//        } else {
//            //redirect to safari because the user doesn't have Instagram
//            print("App not installed")
//            //UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)
//        }
//    }
//
//
    
    //method that sends the SMS message
    func sendSMStatusUpdate (_recipient : String?, _message : String)
    {
        
        //first let's get the list of recipients
        recipientsList.removeAll()
        
        recipientsList.append(_recipient!)
        
        
        let messageVC = MFMessageComposeViewController()
        
        
        messageVC.body = _message;
        messageVC.recipients = recipientsList;
        messageVC.messageComposeDelegate = self;
        
        
        
        self.present(messageVC, animated: false, completion: nil)
        
        
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        

    }

   

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
      
    }
   
}

/*
 //how to get the urlscheme of an ios app
 Download the .ipa from iTunes using my computer
 Copy the application to my desktop
 Rename it to *.zip
 Extract the *.zip
 Open the 'Payload' folder
 Right click on the application and select 'Show Package Contents'
 I then double-click the 'Info.plist' file (which Xcode should then open)
 Then check 'URL types' > 'Item 0' > 'URL Schemes'
*/

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

    
    @objc var recipientsList = [String]()
    
   
    @objc var statusMessageToSend = ""
    
    @objc var studentPhoneNumber  = ""
    
    //now all the button action methods
    
    
  
    
    
    
    
    //method that sends the SMS message
    @objc func sendSMStatusUpdate (_recipient : String?, _message : String)
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

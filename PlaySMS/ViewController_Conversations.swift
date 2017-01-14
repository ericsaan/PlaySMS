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
    
    @IBOutlet weak var lblBigBorder: UILabel!
    
    var statusMessageToSend = ""

    
    //now all the button action methods
    
    
    
    @IBAction func btnTakeBusX(_ sender: UIButton)
    {
       sendSMStatusUpdate(_recipient: "4257851934", _message: "Take Bus ")
        
        
    }
   
    
    @IBAction func btnHowsTraffic(_ sender: UIButton)
    {
        sendSMStatusUpdate(_recipient: "4257851934", _message: "How's Traffic? ")
    }
    
    
    
    
    @IBAction func btnWhereRU(_ sender: UIButton)
    {
        
        //let instagramHooks = "instagram://user?username=your_username"
        let findMyFriendsHooks = "findmyfriends://"
        let appUrl = URL(string: findMyFriendsHooks)
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            UIApplication.shared.open(appUrl!)
            
        } else {
            //redirect to safari because the user doesn't have Instagram
            print("App not installed")
            UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)
        }
    }
    
    @IBAction func btnLittleLate(_ sender: UIButton)
    {
        sendSMStatusUpdate(_recipient: "4257851934", _message: "I'll be a little late... ")
    }
    
    
    @IBAction func btn10MinutesAway(_ sender: UIButton)
    {
        sendSMStatusUpdate(_recipient: "4257851934", _message: "10 Minutes Away... ")
    }
    
    @IBAction func btn5MinutesAway(_ sender: UIButton)
    {
        sendSMStatusUpdate(_recipient: "4257851934", _message: "5 Minutes Away ")
    }
    
    @IBAction func btnImHere(_ sender: UIButton)
    {
        sendSMStatusUpdate(_recipient: "4257851934", _message: "I'm Here! ")
    }
    
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
        
        //make sure we check for nil here or simulator
        //if (MFMessageComposeViewController.canSendText()
        
        
        self.present(messageVC, animated: false, completion: nil)
        
        
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        let lakeSideGold = UIColor(displayP3Red: 1.0, green: 0.76078431, blue: 0.0, alpha: 1.0)
        lblBigBorder.layer.borderColor = lakeSideGold.cgColor
        lblBigBorder.layer.borderWidth = 2
        lblBigBorder.layer.borderColor = lakeSideGold.cgColor
        
    }
   
}

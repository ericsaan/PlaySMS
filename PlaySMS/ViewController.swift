//
//  ViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 12/31/16.
//  Copyright © 2016 Sully. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate
{

    var recipientsList = [String]()
    
    
    var statusMessageToSend = ""
    
    @IBOutlet weak var imageViewBorderActivityBus: UIImageView!
    
    @IBOutlet weak var callMamaSwitch: UISwitch!
    
    @IBOutlet weak var callDaddySwitch: UISwitch!
    
    //@IBOutlet weak var btnText989Afternoon: UIButton!
    
    //@IBOutlet weak var btnText986Afternoon: UIButton!
    
    @IBOutlet weak var lbl981Border: UILabel!
    
    @IBOutlet weak var lbl986Border: UILabel!
    
    @IBOutlet weak var lblAfternoon: UILabel!
    
    @IBOutlet weak var lblBigBorder: UILabel!
    
    
    
    @IBAction func btn989Afternoon(_ sender: Any)
    {
        statusMessageToSend = ""
        statusMessageToSend = "(989) Afternoon - I'm on the Bus. "
              sendSMStatusUpdate()
    }
    
    @IBAction func btn986Afternoon(_ sender: Any)
    {
        statusMessageToSend = ""
        statusMessageToSend = "(982) Afternoon - I'm on the Bus. "
              sendSMStatusUpdate()
    }
    
    @IBAction func btn981ActivityBus(_ sender: Any)
    {
        statusMessageToSend = ""
        statusMessageToSend = "(981) Evening - I'm on the Bus. "
              sendSMStatusUpdate()
    }
    
    
    
    @IBAction func btnTxtDaddy(_ sender: UIButton)  // note ths is the 986 Morning Button
        
    {
        statusMessageToSend = ""
        statusMessageToSend = "(986) Morning - I'm on the Bus. "
                   sendSMStatusUpdate()
        
        
    }
    
    
    
    @IBAction func btnImhere(_ sender: UIButton)
    {
        statusMessageToSend = ""
        statusMessageToSend = "I'm Here! "
        sendSMStatusUpdate()
        
    }
    
    
    @IBAction func btnPickedUp(_ sender: UIButton)
    {
        statusMessageToSend = ""
        statusMessageToSend = "Picked Up! "
        sendSMStatusUpdate()
        
    }
    
    
    
    
    func sendSMStatusUpdate ()
    {

        //first let's get the list of recipients
        recipientsList.removeAll()
        
        if (callMamaSwitch.isOn)
        {
            recipientsList.append("4252411902")
        }
        
        if (callDaddySwitch.isOn)
        {
            recipientsList.append("4252411879")
        }
    
        
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body =   statusMessageToSend

        // MessageVC.recipients = ["4252411879"];
        messageVC.recipients = recipientsList;
        messageVC.messageComposeDelegate = self;
        
        //make sure we check for nil here or simulator
         //if (MFMessageComposeViewController.canSendText()
        
        
            self.present(messageVC, animated: false, completion: nil)
        
        
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
       //imageViewBorderActivityBus.layer.borderColor = UIColor.white.cgColor
       //imageViewBorderActivityBus.layer.borderWidth = 2
        lbl981Border.layer.borderWidth = 1
        lbl981Border.layer.borderColor = UIColor.white.cgColor
        
        let lakeSideGold = UIColor(displayP3Red: 1.0, green: 0.76078431, blue: 0.0, alpha: 1.0)
        lbl981Border.layer.borderColor = lakeSideGold.cgColor
        
        //lbl981Border.layer.borderColor = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0]

        lbl986Border.layer.borderWidth = 1
        //lbl986Border.layer.borderColor = UIColor.white.cgColor
        lbl986Border.layer.borderColor = lakeSideGold.cgColor
        
        lblAfternoon.layer.borderWidth = 1
        //lblAfternoon.layer.borderColor = UIColor.white.cgColor
        lblAfternoon.layer.borderColor = lakeSideGold.cgColor
        
        lblBigBorder.layer.borderWidth = 2
        lblBigBorder.layer.borderColor = lakeSideGold.cgColor
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


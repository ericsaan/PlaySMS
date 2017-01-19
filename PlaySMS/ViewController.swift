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
       //let kid = UserDefaults.standard.value(forKey: "Kid") as? String ?? String()
    
    
    var parentOne = ""
    var parentTwo = ""
    
    @IBOutlet weak var lblParentOne: UILabel!
    
    @IBOutlet weak var lblParentTwo: UILabel!
    
    /*
 
 
 980
     982
     986
     987
     988
     989
     994
     995
     981
     984
 
 */
    
    
    
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
    
    @IBAction func btn980(_ sender: UIButton)
    {
        
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
        
    }
    
    @IBAction func btn982(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    @IBAction func btn986(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)

    }
    
    
       
    @IBAction func btn987(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    
    @IBAction func btn988(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
   
    @IBAction func btn989(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    
    
    @IBAction func btn994(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    @IBAction func btn995(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    @IBAction func btn981(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    @IBAction func btn984(_ sender: UIButton)
    {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    
    @IBAction func btnImhere(_ sender: UIButton)
    {
        let statusMessageToSend = "I'm Here! "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
    
    
    @IBAction func btnPickedUp(_ sender: UIButton)
    {
        let statusMessageToSend = "Picked Up! "
        sendSMStatusUpdate(messageToSend: statusMessageToSend)
    }
        
    
      
    
    
    
    
    //****************************************************
    //need to refactor to get better encapsulation...ees
    //****************************************************
    
    func sendSMStatusUpdate (messageToSend : String)
    {

        //first let's get the list of recipients
        recipientsList.removeAll()
        
        if (callMamaSwitch.isOn)
        {
           // recipientsList.append("4252411902")
            parentOne = UserDefaults.standard.value(forKey: "ContactOnePhoneNumber") as! String!
            
            if parentOne != ""
            {
                recipientsList.append(parentOne)
                print (parentOne)
            }
            
            
            
        }
        
        if (callDaddySwitch.isOn)
        {
            //recipientsList.append("4252411879")
            parentTwo = UserDefaults.standard.value(forKey: "ContactTwoPhoneNumber") as! String!
            
            if parentTwo != ""
            {
                recipientsList.append(parentTwo)
                print (parentTwo)
            }
        }
    
        
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body =   messageToSend
        

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
        
        
        //at first we are just checkign to making it work. next we will read in first
        
            /*
        UserDefaults.standard.set(parentOne, forKey: "ParentOne")
        UserDefaults.standard.set(parentTwo, forKey: "ParentTwo")
        UserDefaults.standard.set(kid, forKey: "Kid")
        */
        
        
        let parentOne = UserDefaults.standard.value(forKey: "ParentOne") as? String ?? String()
        let parentTwo = UserDefaults.standard.value(forKey: "ParentTwo") as? String ?? String()

        print(parentOne)
        print(parentTwo)
        
        
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
       
        //first let's set the text values of the buttons
        lblParentOne.text = UserDefaults.standard.value(forKey: "ContactOneName") as! String?
        lblParentTwo.text = UserDefaults.standard.value(forKey: "ContactTwoName") as! String!
        
        if lblParentOne.text == nil
        {
            lblParentOne.text = "P/G One"
        }
        if lblParentTwo.text == nil
        {
            lblParentTwo.text = "P/G Two"
        }
        
        
        
        //next we create the gold color and then apply it to the label borders
        let lakeSideGold = UIColor(displayP3Red: 1.0, green: 0.76078431, blue: 0.0, alpha: 1.0)
        
       
        lbl986Border.layer.borderWidth = 1
        lbl986Border.layer.borderColor = lakeSideGold.cgColor
        
        lblAfternoon.layer.borderWidth = 1
        lblAfternoon.layer.borderColor = lakeSideGold.cgColor
        
        lblBigBorder.layer.borderWidth = 2
        lblBigBorder.layer.borderColor = lakeSideGold.cgColor
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


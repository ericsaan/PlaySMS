//
//  ChatViewController.swift
//  PlaySMS
//  Created by Eric Sullivan.
//  Copyright (c) 2018 Moonsspec Design All rights reserved.
//

import UIKit
import Firebase

//import ChameleonFramework

//, UITextFieldDelegate
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    @objc var studentName: String?
    @objc var dateString: String?
    @objc var appUserName: String?
    @objc var senderName: String?
    @objc var receiverName: String?
    @objc var receiverName1: String?
    @objc var receiverName2: String?
    
    var settingsData: Settings = Settings()
    
    @IBOutlet weak var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsData.refreshSettings()
        appUserName = settingsData.appUserName
        
       
        dateString = getDateString()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
       
       

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        //configureTableView()
        retrieveMessages()
      
        messageTableView.separatorStyle = .none
        messageTableView.reloadData()
        self.view.layoutIfNeeded()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
       //scrollTobottom()
     }
    override func viewWillAppear(_ animated: Bool) {
        
        settingsData.refreshSettings()
        setBackgrounds()
        messageTableView.reloadData()
        scrollTobottom()
    }
    
    
    //***********************************************************************************
    
    func setBackgrounds() {
        settingsData.refreshSettings()
        switch settingsData.skinLogo {
        case "Evergreen":
            self.view.backgroundColor = settingsData.swiftColorEvergreen
            self.messageTableView.backgroundColor = settingsData.swiftColorEvergreen
            
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorEvergreen
            //self.composeViewer.backgroundColor = settingsData.swiftColorEvergreen
            
        case "University Prep":
            self.messageTableView.backgroundColor = settingsData.swiftColorUniversityPrep
            self.view.backgroundColor = settingsData.swiftColorUniversityPrep
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorUniversityPrep
            //self.composeViewer.backgroundColor = settingsData.swiftColorUniversityPrep
            
        case "Neutral":
            self.view.backgroundColor = UIColor.black //settingsData.swiftColorNeutral
            self.messageTableView.backgroundColor = settingsData.swiftColorNeutral
            self.tabBarController?.tabBar.barTintColor = UIColor.black //settingsData.swiftColorNeutral
           // self.composeViewer.backgroundColor = settingsData.swiftColorNeutral
            
            
        default:
            self.view.backgroundColor = settingsData.swiftColorLakeside
            self.messageTableView.backgroundColor = settingsData.swiftColorLakeside
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorLakeside
            //self.composeViewer.backgroundColor = settingsData.swiftColorLakeside
            
        }  //endswitch
        self.view.layoutIfNeeded()
    }  //endsetbackground
    
    //***********************************************************************************
    
    func cellBackgroundColor() -> UIColor {
        settingsData.refreshSettings()
        
        switch settingsData.skinLogo {
        case "Evergreen":

            return settingsData.swiftColorEvergreen
            
        case "University Prep":
            return settingsData.swiftColorUniversityPrep
            
        case "Neutral":
            return settingsData.swiftColorNeutral
            
            
        default:
            return settingsData.swiftColorLakeside
            
        }  //endswitch
   
       
    }  //endsetbackground
    
    //***********************************************************************************
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor =  cellBackgroundColor()
        self.view.setNeedsLayout()
        //tableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
   
 
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        let senderName = messageArray[indexPath.row].senderName
        if senderName != "" {
            cell.senderUsername.text = " " + messageArray[indexPath.row].senderName + " - " + messageArray[indexPath.row].dateSent
        } else {
            cell.senderUsername.text = " " + messageArray[indexPath.row].sender + " - " + messageArray[indexPath.row].dateSent
        }
        
        
        //TODO: filter to receiving app user
        if messageArray[indexPath.row].sender == appUserName
            // Auth.auth().currentUser?.email as String?
        {
            cell.messageBackground.backgroundColor = UIColor.gray   // flatBlue()
            cell.senderUsername.textColor = UIColor.white
            cell.messageBody.backgroundColor = UIColor.gray
            cell.messageBody.textColor = UIColor.white
        }
        else{
            cell.messageBackground.backgroundColor = UIColor.darkGray   //.flatWhite()
            cell.messageBody.backgroundColor = UIColor.darkGray
            cell.messageBody.textColor = UIColor.white
            cell.senderUsername.textColor = UIColor.white
            
        }
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count 
        
        
           }

    
    
    
    //TODO: Declare tableViewTapped here:

    
    //TODO: Declare configureTableView here:
    @objc func configureTableView()
    {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
//    //TODO: Create the retrieveMessages method here:
//
     @objc func retrieveMessages()
     {
        let messageDB = Database.database().reference().child("Messages")
        
        settingsData.refreshSettings()
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let senderName = snapshotValue["SenderName"]!
            
            let receiver = snapshotValue["Receiver"]!
            let receiverName = snapshotValue["ReceiverName"]!
            
            let dateString = snapshotValue["DateString"]!
            
            //print (text, sender)
            let message = Message()
            message.messageBody = text.padding(toLength: 43, withPad: " ", startingAt: 0)
             
            message.sender   = sender
            message.senderName = senderName
            message.receiver = receiver
            message.receiverName  = receiverName
            message.dateSent = dateString
            
            
            //don't append message if not intended for app user or not sent by user
            //***************************************************************************************
           
          
            
            if self.settingsData.appUserName == message.receiver  {
               self.messageArray.append(message)
                
            }
            
            //now for messages the app user has sent, only need 1 record even though 2 messages were sent
            if self.messageArray.count > 0 {
                
                
                let senderCheck = message  //self.messageArray[self.messageArray.count - 1]
                
                
                if self.settingsData.appUserName == senderCheck.sender {
                        self.messageArray.append(message)
                }
            } else {
           
                if self.settingsData.appUserName == message.sender {
                    self.messageArray.append(message)
                    
                }
            }
            
                self.configureTableView()
            self.messageTableView.reloadData()
            self.scrollTobottom()

            
        })
      //print("done retrieving")
    }
    
    //***************************************************************************************
    
    @objc func scrollTobottom() {
        let scrollPoint = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
        self.messageTableView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    //***************************************************************************************
    
    @objc func getDateString() -> String {
        
        
        let date = Date()
        
       
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: date)
        
        
        
        return dateString
    }
    //***************************************************************************************
    

}

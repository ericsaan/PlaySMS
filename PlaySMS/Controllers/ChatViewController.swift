//
//  ChatViewController.swift
//  PlaySMS
//  Created by Eric Sullivan.
//  Copyright (c) 2018 Moonsspec Design All rights reserved.
//

import UIKit
import Firebase
//import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    @objc var studentName: String?
    @objc var dateString: String?
    @objc var appUserName: String?
    
    var settingsData: Settings = Settings()
    
    
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet  var sendButton: UIButton!
    @IBOutlet  var messageTextfield: UITextField!
  
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsData.refreshSettings()
        appUserName = settingsData.appUserName
        
       
        dateString = getDateString()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
      
        messageTableView.separatorStyle = .none
       
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
       //scrollTobottom()
     }
    override func viewWillAppear(_ animated: Bool) {
       scrollTobottom()
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
   
 
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = " " + messageArray[indexPath.row].sender + " - " + messageArray[indexPath.row].dateSent
        
        
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
            cell.messageBackground.backgroundColor = UIColor.white   //.flatWhite()
            cell.messageBody.backgroundColor = UIColor.white
            cell.messageBody.textColor = UIColor.black
            cell.senderUsername.textColor = UIColor.black
        }
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count 
        
        
           }

    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped()
    {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    @objc func configureTableView()
    {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        UIView.animate(withDuration: 0.5)
            {
               self.heightConstraint.constant = 323
              
                self.view.layoutIfNeeded()
            }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        UIView.animate(withDuration: 0.5)
        {
           self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    //@IBAction func sendPressed(_ sender: AnyObject)
    @IBAction func sendPressed(_ sender: Any)
    {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        
        //hit the database
        let dateString = getDateString()
        let messageIn = messageTextfield.text!
        let messageToSend = messageIn.padding(toLength: 44, withPad: " ", startingAt: 0)
        print("length is-> \(messageToSend.count)")
        
        
        studentName = messageArray[messageArray.count - 1].sender  //get last sender and respond to them
        
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": appUserName, //Auth.auth().currentUser?.email,
            "MessageBody": messageToSend,"Receiver": studentName!,"DateString": dateString]
        
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil{
                print(error!)
            }else {
                print ("message saved successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
                self.scrollTobottom()
            
            }
        }
        
                
    }  //endsendpressed
    
    //TODO: Create the retrieveMessages method here:
    
     @objc func retrieveMessages()
     {
        let messageDB = Database.database().reference().child("Messages")
        
        settingsData.refreshSettings()
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let receiver = snapshotValue["Receiver"]!
            let dateString = snapshotValue["DateString"]!
            
            //print (text, sender)
            let message = Message()
            message.messageBody = text.padding(toLength: 44, withPad: " ", startingAt: 0)
             
            message.sender   = sender
            message.receiver = receiver
            message.dateSent = dateString
            
            
            //don't append message if not intended for app user or not sent by user
            //***************************************************************************************
            if self.settingsData.appUserName == message.receiver  {
               self.messageArray.append(message)
                
            }
            
            //now for messages the app user has sent, only need 1 record even though 2 messages were sent
            if self.messageArray.count > 0 {
                
                
                let senderCheck = self.messageArray[self.messageArray.count - 1]
                
                
                if self.settingsData.appUserName == senderCheck.sender {
                    if senderCheck.dateSent != message.dateSent {
                        self.messageArray.append(message)
                        
                    }
                    
                }
            } else {
                if self.settingsData.appUserName == message.sender {
                    self.messageArray.append(message)
                    
                }
            }
            
            //***************************************************************************************
            self.configureTableView()
            self.messageTableView.reloadData()
            self.scrollTobottom()

            
            
        })
    }
    
    
    @objc func scrollTobottom() {
        let scrollPoint = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
        self.messageTableView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    
    @objc func getDateString() -> String {
        
        
        let date = Date()
        
       
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: date)
        
        
        
        return dateString
    }
    

}

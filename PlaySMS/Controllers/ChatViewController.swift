//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var studentName: String?
    var dateString: String?
    
    
    
    
    // We've pre-linked the IBOutlets
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    
    
   // @IBOutlet  var heightConstraint: NSLayoutConstraint!
    @IBOutlet  var sendButton: UIButton!
    @IBOutlet  var messageTextfield: UITextField!
  
    @IBOutlet var messageTableView: UITableView!
    //@IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        studentName = UserDefaults.standard.value(forKey: "StudentName") as? String
        if studentName == nil {
            studentName = "No Student Specified"
        }
        
       
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

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = " " + messageArray[indexPath.row].sender + "   Time: " + messageArray[indexPath.row].dateSent
        
//        if messageArray[indexPath.row].receiver == appUserName
//            // Auth.auth().currentUser?.email as String?
//        {
//            cell.messageBackground.backgroundColor = UIColor.flatBlue()            
//        }
//        else{
//            cell.messageBackground.backgroundColor = UIColor.flatWhite()
//            
//        }
        
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
    func configureTableView()
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
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": studentName, //Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextfield.text!,"Receiver": studentName!,"DateString": dateString]
        
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil{
                print(error!)
            }else {
                print ("message saved successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            
            
            }
        }
        
        
        
    }  //endsendpressed
    
    //TODO: Create the retrieveMessages method here:
    
     func retrieveMessages()
     {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let receiver = snapshotValue["Receiver"]!
            let dateString = snapshotValue["DateString"]!
            
            //print (text, sender)
            let message = Message()
            message.messageBody = text
            message.sender   = sender
            message.receiver = receiver
            message.dateSent = dateString
            
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
            
        })
    }
    
    
    
    func getDateString() -> String {
        
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let dateString = String(hour) + ":" + String(minute)
        return dateString
    }
    
//    @IBAction func logOutPressed(_ sender: AnyObject) {
//        
//        //TODO: Log out the user and send them back to WelcomeViewController
//        do
//        {
//            try Auth.auth().signOut()
//            navigationController?.popToRootViewController(animated: true)
//            
//        }
//        catch
//        {
//            print ("Error, there was a problem signing out")
//        }
//        
//        
//    }
    


}

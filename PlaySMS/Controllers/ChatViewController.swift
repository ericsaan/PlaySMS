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
    var appUserName: String?
    
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
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cast = messageArray.filter($0.receiver = appUserName)
        
        
//        Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.
//        In this example, filter(_:) is used to include only names shorter than five characters.
//        let cast = ["Vivien", "Marlon", "Kim", "Karl"]
//        let shortNames = cast.filter { $0.count < 5 }
//
        
        //let receiverNames = messageArray.filter { $0.receiver = appUserName }
//
//        messageArray.filter {
//            $0.receiver.contains({ $0.receiver == appUserName })
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
//        cell.messageBody.text = receiverNames[indexPath.row].messageBody
//        cell.senderUsername.text = " " + receiverNames[indexPath.row].sender + "   Time: " + receiverNames[indexPath.row].dateSent
        
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = " " + messageArray[indexPath.row].sender + "   Time: " + messageArray[indexPath.row].dateSent
        
        
        //TODO: filter to receiving app user
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
        
        //TODO: NOTE: send message back, note this will not work with 2 students :( need to refactor
        
        studentName = messageArray[messageArray.count - 1].sender  //get last sender and respond to them
        
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": appUserName, //Auth.auth().currentUser?.email,
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
                self.scrollTobottom()
            
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
            self.scrollTobottom()

            
            
        })
    }
    
    
    func scrollTobottom() {
        let scrollPoint = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
        self.messageTableView.setContentOffset(scrollPoint, animated: true)
        
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

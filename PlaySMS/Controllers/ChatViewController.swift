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
        
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
   
        //TODO: Fix the string length
        let blankString: String = "                                                                      "
        var messagePadding: String = ""
        
        if messageArray[indexPath.row].messageBody.count < 62 {
            messagePadding = String(blankString.suffix((62-messageArray[indexPath.row].messageBody.count)))
            messageArray[indexPath.row].messageBody += messagePadding
            
        }
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = " " + messageArray[indexPath.row].sender + "   Date: " + messageArray[indexPath.row].dateSent
        
        
        //TODO: filter to receiving app user
        if messageArray[indexPath.row].sender == appUserName
            // Auth.auth().currentUser?.email as String?
        {
            cell.messageBackground.backgroundColor = UIColor.flatBlue()
            cell.senderUsername.textColor = UIColor.white
            cell.messageBody.backgroundColor = UIColor.flatBlue()
            cell.messageBody.textColor = UIColor.white
        }
        else{
            cell.messageBackground.backgroundColor = UIColor.flatWhite()
            cell.messageBody.backgroundColor = UIColor.flatWhite()
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
        
        settingsData.refreshSettings()
        
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
    
    
    func scrollTobottom() {
        let scrollPoint = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
        self.messageTableView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    
    func getDateString() -> String {
        
        
        let date = Date()
        
       
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .medium
        
        let dateString = formatter.string(from: date)
        
        
        
        
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minute = calendar.component(.minute, from: date)
//        let day = calendar.component((.day), from: date)
//        let dateString = String(hour) + ":" + String(minute) + " Date: " + String(day)
        return dateString
    }
    

    
//    func sendRequestPush()  {
//        // create the request
//        let url = URL(string: "https://fcm.googleapis.com/fcm/send")
//        let request = NSMutableURLRequest(url: url!)
//        request.httpMethod = "POST"
//        request.setValue("key=AIzaSyCGJzqLNwEzYjoB9QwUSma8Y-vJzIDjdUA", forHTTPHeaderField: "authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let parameters = ["to": deviceToken,
//                          "priority": "high",
//                          "notification": ["body":"Hello1", "title":"Hello world","sound":"default"]] as [String : Any]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let dataTask = session.dataTask(with: request as URLRequest) { data,response,error in
//            let httpResponse = response as? HTTPURLResponse
//            if (error != nil) {
//                print(error!)
//            } else {
//                print(httpResponse!)
//            }
//            guard let responseData = data else {
//                print("Error: did not receive data")
//                return
//            }
//            do {
//                guard let responseDictionary = try JSONSerialization.jsonObject(with: responseData, options: [])
//                    as? [String: Any] else {
//                        print("error trying to convert data to JSON")
//                        return
//                }
//                print("The responseDictionary is: " + responseDictionary.description)
//            } catch  {
//                print("error trying to convert data to JSON")
//                return
//            }
//            DispatchQueue.main.async {
//                //Update your UI here
//            }
//        }
//        dataTask.resume()
//    }

}

//
//  Message.swift
//
//
//  This is the model class that represents the blueprint for a message

import UIKit
class Message: NSObject
{
    var sender: String = ""
       var senderName: String = ""
       var messageBody: String = ""
       var receiver: String = ""
       var receiverName: String = ""
       var dateSent : String = ""
       var dateISO: Date = Date()
           
    //TODO: Messages need a messageBody and a sender variable
    required init(sender: String, senderName: String, messageBody: String, receiver: String, receiverName: String, dateString: String, dateISO: String) {
   
        self.sender = sender
        self.senderName = senderName
        self.messageBody = messageBody
        self.receiver = receiver
        self.receiverName = receiverName
        self.dateSent = dateString
        
        
        
//        let isoDate = "2016-04-14T10:44:00+0000"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateSentCalc = dateFormatter.date(from:dateISO)!
        self.dateISO = dateSentCalc

        
              
        

    }
    
}
//DateFormatter() has 5 format style options for each of Date and Time. These are:
//.none .short .medium .long .full
//
// DATE      TIME     DATE/TIME STRING
//"none"    "none"
//"none"    "short"   9:42 AM
//"none"    "medium"  9:42:27 AM
//"none"    "long"    9:42:27 AM EDT
//"none"    "full"    9:42:27 AM Eastern Daylight Time
//"short"   "none"    10/10/17
//"short"   "short"   10/10/17, 9:42 AM
//"short"   "medium"  10/10/17, 9:42:27 AM
//"short"   "long"    10/10/17, 9:42:27 AM EDT
//"short"   "full"    10/10/17, 9:42:27 AM Eastern Daylight Time
//"medium"  "none"    Oct 10, 2017
//"medium"  "short"   Oct 10, 2017, 9:42 AM
//"medium"  "medium"  Oct 10, 2017, 9:42:27 AM
//"medium"  "long"    Oct 10, 2017, 9:42:27 AM EDT
//"medium"  "full"    Oct 10, 2017, 9:42:27 AM Eastern Daylight Time
//"long"    "none"    October 10, 2017
//"long"    "short"   October 10, 2017 at 9:42 AM
//"long"    "medium"  October 10, 2017 at 9:42:27 AM
//"long"    "long"    October 10, 2017 at 9:42:27 AM EDT
//"long"    "full"    October 10, 2017 at 9:42:27 AM Eastern Daylight Time
//"full"    "none"    Tuesday, October 10, 2017
//"full"    "short"   Tuesday, October 10, 2017 at 9:42 AM
//"full"    "medium"  Tuesday, October 10, 2017 at 9:42:27 AM
//"full"    "long"    Tuesday, October 10, 2017 at 9:42:27 AM EDT
//"full"    "full"    Tuesday, October 10, 2017 at 9:42:27 AM Eastern Daylight Time

//
//  ViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 12/31/16.
//  Copyright © 2016 Sully. All rights reserved.
//

import UIKit
import MessageUI
import Cheers
import Firebase
import GoogleSignIn
import CoreLocation

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, GIDSignInUIDelegate, CLLocationManagerDelegate
{
    //location
    let locationManager = CLLocationManager()

    
    let emitterLayer = CAEmitterLayer()
    @objc let cheerView = CheerView()
    @objc var recipientsList = [String]()
    @objc var recipientsListNames = [String]()
    @objc var statusMessageToSend = ""
    @objc var parentOne: String? = ""
    @objc var parentOneName: String? = ""
    @objc var parentTwo: String? = ""
    @objc var parentTwoName: String? = ""
    @objc var appUserName: String? = ""
    @objc var senderName: String? = ""
    @objc var busRoute1: String? = ""
    @objc var busRoute2: String? = ""
    @objc var busRoute3: String? = ""
    @objc var switchConfetti: String? = "1"
    
    var settingsData: Settings = Settings()
    
    @IBOutlet weak var imgLakeside: UIImageView!
    @IBOutlet weak var lblOnTheBus: UILabel!
    @IBOutlet weak var butRoute1: UIButton!
    @IBOutlet weak var butRoute2: UIButton!
    @IBOutlet weak var butRoute3: UIButton!
    @IBOutlet weak var butImHere: UIButton!
    @IBOutlet weak var butPickedUp: UIButton!
    @IBOutlet weak var butGettingClose: UIButton!

    
    
    
    
    
    //pickerview
    @IBOutlet weak var butLogo: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
 
    //************************************************************************
    
    @IBAction func btnGettingClosePressed(_ sender: UIButton) {
        
        let statusMessageToSend = getCloseText()  //custom text based on email from sullivan or fitzgerald families
        
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
        
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
            
            
            if switchConfetti == "1" {
                popConfetti()
            }
        }
        
    }
    
    //************************************************************************
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
       
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
            
            if switchConfetti == "1" {
                popConfetti()
            }
        }
        
    }
    //************************************************************************
    
    @IBAction func btn2Pressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
        
            if switchConfetti == "1" {
                popConfetti()
            }
        }
    }
    //************************************************************************
    
    @IBAction func btn3Pressed(_ sender: UIButton) {
        let statusMessageToSend = "(" + sender.currentTitle! + ") " + MorningOrAfternoon() + " - I'm on the Bus. "
        //sendSMStatusUpdate(messageToSend: statusMessageToSend)
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
            
            if switchConfetti == "1" {
                popConfetti()
            }
        }
    }
    //************************************************************************
    
    @IBAction func btnImhere(_ sender: UIButton)
    {
      
        let statusMessageToSend = "I'm Here!                                                    "
        
            UIButton.animate(withDuration: 0.2,
                             animations: {
                                sender.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
            },
                             completion: { finish in
                                UIButton.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity
                                })
            })
            if sendMessageToDatabase(messageToSend: statusMessageToSend) {
                
                
                if switchConfetti == "1" {
                    popConfetti()
                }
            }
      }
    
    //************************************************************************
    
    @IBAction func btnPickedUp(_ sender: UIButton)
    {
        let statusMessageToSend = "Picked Up!                                                   "
        
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
        
       
        if sendMessageToDatabase(messageToSend: statusMessageToSend) {
            
            
            if switchConfetti == "1" {
                popConfetti()
            }
        }
        
    }
        
    //************************************************************************
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cheerView.frame = view.bounds
    }
    
    
    //****************************************************
    //need to refactor to get better encapsulation...ees
    //****************************************************
    @objc func sendMessageToDatabase(messageToSend : String) -> Bool
    {
        
        if Auth.auth().currentUser == nil {
            //call login for google
           //alert sign in on the settings page then segue
            let alert = UIAlertController(title: "Login Alert", message: "You need to login...", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alert.addAction(defaultAction)
            present(alert, animated: true)
            return false
          
        } else {
         
            //first let's get the list of recipients
            recipientsList.removeAll()
            recipientsListNames.removeAll()
            
            settingsData.refreshSettings()
            parentOne = settingsData.contactOne
            parentTwo = settingsData.contactTwo
            parentOneName = settingsData.contactOnePhoneNumber
            parentTwoName = settingsData.contactTwoPhoneNumber
            senderName = settingsData.appUserPhoneNumber
            
            switchConfetti = settingsData.switchConfetti
            
            let messageToSendOut = messageToSend.padding(toLength: 50, withPad: " ", startingAt: 0)
            //print("length is-> \(messageToSendOut.count)")
                
            if  parentOne != nil && parentOne != ""
            {
                recipientsList.append(parentOne!)
                recipientsListNames.append(parentOneName!)
               // print (parentOne!)
            }
            
          
            if parentTwo != nil && parentTwo != ""
            {
                recipientsList.append(parentTwo!)
                recipientsListNames.append(parentTwoName!)
                //print (parentTwo!)
            }

             appUserName = settingsData.appUserName
             if appUserName == nil{
                appUserName = "No App User Specified"
            }
            
            if recipientsList.count != 0
            {
                //**********
                //now to write to cloudstore
                //**********
                
                recipientsList.append(appUserName!)
                recipientsListNames.append(senderName!)

                let userDB = Firestore.firestore()
                let settings = userDB.settings
                settings.areTimestampsInSnapshotsEnabled = true
                userDB.settings = settings
                
                userDB.collection("messages")
                
                for i in 0 ... recipientsList.count - 1
                {
                    let dateString = getDateString()
          
                    var ref: DocumentReference? = nil
                    ref = userDB.collection("messages").addDocument(data: [
                        "Receiver": recipientsList[i],
                        "ReceiverName": recipientsListNames[i],
                        "MessageBody": messageToSendOut,
                        "Sender": appUserName!,
                        "SenderName": senderName!,
                        "DateString": dateString
                        
                    ]) { err in
                            if let err = err {
                                print("Error adding message document: \(err)")
                            } else {
                                print("Document added with ID: \(ref!.documentID)")
                            }
                        } //enderr
                    
                } //endforloop
                
                // end write to cloudstore
                //***************************
            } //endif loop
        }//end if on user = nil
        
        return true
    }
    
    //************************************************************************
   
    //************************************************************************
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
   
    //************************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //location
        //2. setup location manager
               locationManager.delegate = self
               locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               
           //3. setup mapView
//               mapView.delegate = self
//               mapView.showsUserLocation  = true
//               mapView.userTrackingMode = .follow
//
           //4. setup test data
             setupData()
        //end location

        
        
        
        cheerView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        view.addSubview(cheerView)

        //to pick skins
        pickerView.delegate = self
        pickerView.dataSource = self
        //call login for google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }

    //************************************************************************
    
    
    //location code
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
        
           // 1. status is not determined
           if CLLocationManager.authorizationStatus() == .notDetermined {
               locationManager.requestAlwaysAuthorization()
               
           }
           // 2. authorization were denied
           else if CLLocationManager.authorizationStatus() == .denied {
               
               showAlert(textToShow: "Location services were previously denied. Please enable location services for this app in Settings.")
           }
           // 3. we do have authorization
           else if CLLocationManager.authorizationStatus() == .authorizedAlways {
               locationManager.startUpdatingLocation()
           }
       }
    //*********************************************************************
     func setupData() {
            // 1. check if system can monitor regions
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
         
                // 2. region data
                let title = "520- Portage Bay"
               // let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
                let coordinate = CLLocationCoordinate2DMake(47.643018, -122.315538)
                
                let regionRadius = 300.0
         
                // 3. setup region
                let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                    longitude: coordinate.longitude), radius: regionRadius, identifier: title)
                locationManager.startMonitoring(for: region)
         
                // 4. setup annotation
//                let restaurantAnnotation = MKPointAnnotation()
//                restaurantAnnotation.coordinate = coordinate;
//                restaurantAnnotation.title = "\(title)";
//                mapView.addAnnotation(restaurantAnnotation)
//
//                // 5. setup circle
//                let circle = MKCircle(center: coordinate, radius: regionRadius)
//                mapView.addOverlay(circle)
            }
            else {
                print("System can't track regions")
            }
        }
         
        // 6. draw circle
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            let circleRenderer = MKCircleRenderer(overlay: overlay)
//            circleRenderer.strokeColor = UIColor.red
//            circleRenderer.lineWidth = 1.0
//            return circleRenderer
//        }//end mapview
//

      
        // 1. user enter region
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            showAlert(textToShow: "enter \(region.identifier)")
            
            let statusMessageToSend =  " I'm on the 520 Bridge. "
            
           //let statusMessageToSend = "(" + appUserName! + ") " + "- I'm on the 520 Bridge. "
                        
//                //sendSMStatusUpdate(messageToSend: statusMessageToSend)
                   if sendMessageToDatabase(messageToSend: statusMessageToSend) {
                   
//                       if switchConfetti == "1" {
//                           popConfetti()
//                       }
                   }
        }
    
        
         
        // 2. user exit region
//        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//           //showAlert(textToShow: "exit \(region.identifier)")
//        }


    //showAlert function
        func showAlert(textToShow: String?){
            let alertController = UIAlertController(title: "Locations", message:
                           textToShow, preferredStyle: .alert)
                       alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                       self.present(alertController, animated: true, completion: nil)
                    
        }
    //*********************** end location code **********************************************
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        //get all the user defaults and assign to variables
        settingsData.refreshSettings()
        parentOne = settingsData.contactOne
        parentTwo = settingsData.contactTwo
        appUserName = settingsData.appUserName
        busRoute1 = settingsData.busRoute1
        busRoute2 = settingsData.busRoute2
        busRoute3 = settingsData.busRoute3
        switchConfetti = settingsData.switchConfetti
        
        //set the titles of the 3 primary buttons
        butRoute1.setTitle(busRoute1, for: .normal)
        butRoute2.setTitle(busRoute2, for: .normal)
        butRoute3.setTitle(busRoute3, for: .normal)
        
        pickerView.isHidden = true
        
        //now to set the background
        setBackgrounds()
        
        mainSettingsLayout()
    }  //end will appear
    
   //*****************************************************************************************************
    func setBackgrounds() {
   
      switch settingsData.skinLogo {
        case "Evergreen":
            let logo = settingsData.skinEvergreen
            butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorEvergreen
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorEvergreen
            self.lblOnTheBus.textColor = UIColor.white
            self.butRoute1.setBackgroundImage(UIImage(named: "EvergreenButton.png"), for: .normal)
            self.butRoute2.setBackgroundImage(UIImage(named: "EvergreenButton.png"), for: .normal)
            self.butRoute3.setBackgroundImage(UIImage(named: "EvergreenButton.png"), for: .normal)
            self.butImHere.setBackgroundImage(UIImage(named: "EvergreenButton.png"), for: .normal)
            self.butPickedUp.setBackgroundImage(UIImage(named: "EvergreenButton.png"), for: .normal)
            self.butGettingClose.setTitleColor(UIColor.white, for: .normal)
            self.butGettingClose.setTitle(getCloseText(), for: .normal)
                
                
        case "University Prep":
            let logo = settingsData.skinUniversityPrep
            butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorUniversityPrep
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorUniversityPrep
            self.lblOnTheBus.textColor = UIColor.white
            self.butRoute1.setBackgroundImage(UIImage(named: "UPrep.png"), for: .normal)
            self.butRoute2.setBackgroundImage(UIImage(named: "UPrep.png"), for: .normal)
            self.butRoute3.setBackgroundImage(UIImage(named: "UPrep.png"), for: .normal)
            self.butImHere.setBackgroundImage(UIImage(named: "UPrep.png"), for: .normal)
            self.butPickedUp.setBackgroundImage(UIImage(named: "UPrep.png"), for: .normal)
            self.butGettingClose.setTitleColor(UIColor.white, for: .normal)
            self.butGettingClose.setTitle(getCloseText(), for: .normal)
        
                
        case "Neutral":
            let logo = settingsData.skinNeutral
            butLogo.setImage(UIImage(named: logo), for: .normal)
            
            self.view.backgroundColor = settingsData.swiftColorNeutral
            self.tabBarController?.tabBar.barTintColor = UIColor.black
            self.butRoute1.setBackgroundImage(UIImage(named: "BlackButton.png"), for: .normal)
            self.butRoute2.setBackgroundImage(UIImage(named: "BlackButton.png"), for: .normal)
            self.butRoute3.setBackgroundImage(UIImage(named: "BlackButton.png"), for: .normal)
            self.butImHere.setBackgroundImage(UIImage(named: "BlackButton.png"), for: .normal)
            self.butPickedUp.setBackgroundImage(UIImage(named: "BlackButton.png"), for: .normal)
            self.lblOnTheBus.textColor = UIColor.black
            self.butGettingClose.setTitleColor(UIColor.black, for: .normal)
            self.butGettingClose.setTitle(getCloseText(), for: .normal)
    
            
           
            
        default:
            let logo = settingsData.skinLakeside
            butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorLakeside
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorLakeside
            self.butRoute1.setBackgroundImage(UIImage(named: "RedButtonGoldBorder"), for: .normal)
            self.butRoute2.setBackgroundImage(UIImage(named: "RedButtonGoldBorder"), for: .normal)
            self.butRoute3.setBackgroundImage(UIImage(named: "RedButtonGoldBorder"), for: .normal)
            self.butImHere.setBackgroundImage(UIImage(named: "RedButtonGoldBorder"), for: .normal)
            self.butPickedUp.setBackgroundImage(UIImage(named: "RedButtonGoldBorder"), for: .normal)
            self.lblOnTheBus.textColor = UIColor.white
            self.butGettingClose.setTitleColor(UIColor.white, for: .normal)
            self.butGettingClose.setTitle(getCloseText(), for: .normal)
        
        
        }  //endswitch
        self.view.layoutIfNeeded()
    }  //endsetbackground
    
    //***************************************************************************************
    func getCloseText()-> String {
       switch settingsData.appUserName {
        
       case "katherines23@lakesideschool.org", "ericsaan@gmail.com", "sullynat@gmail.com","gregfitz99@gmail.com", "marypellyfitzgerald@gmail.com","jenniferf23@lakesideschool.org":
       
            return "            " //used to be "on 520" for designated emails but took out with location aware feature
        
        default:
            return "           " //used to be "Getting Close" for designated emails but took out with location aware feature
       }
        
     }
  
    //***************************************************************************************
    
    @IBAction func btnSelectLogo(_ sender: UIButton) {
    pickerView.isHidden = false
    }
    
    //*******************************************
    @objc func mainSettingsLayout() {
        let screenWidth = Int(self.view.frame.width)
        let iPhoneVer: IPhoneVersion = IPhoneVersion()
        let r1BallX = self.view.center.x - 134
        let r2BallX = self.view.center.x-1
        let ballSize: CGFloat = 134
        
        lblOnTheBus.center.x = self.view.center.x
        
        switch screenWidth {
        case iPhoneVer.iPhone6PlusWidth, iPhoneVer.iPhone6sPlusWidth, iPhoneVer.iPhone7PlusWidth, iPhoneVer.iPhone8PlusWidth, iPhoneVer.iPhone8Width, iPhoneVer.iPhoneXWidth:
            
            butRoute1.frame.size.width = ballSize
            butRoute1.frame.size.height = ballSize
            butRoute1.frame.origin.x = r1BallX
            
            butRoute2.frame.size.width = ballSize
            butRoute2.frame.size.height = ballSize
            butRoute2.frame.origin.x = r2BallX
            
            butRoute3.frame.size.width = ballSize
            butRoute3.frame.size.height = ballSize
            butRoute3.center.x = self.view.center.x
            butRoute3.frame.origin.y = butRoute1.frame.origin.y + 112
            
        default:
            return
            
        }
        self.view.layoutIfNeeded()
        
    }
    
    //******************************************
    @objc func MorningOrAfternoon() -> String
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
    @objc func popConfetti() {
     
        cheerView.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
        self.cheerView.stop()
        }
     } //  endpopconfetti
    
    //******************************************
        
    @objc func getDateString() -> String {
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = .short
       
        let dateString = formatter.string(from: date)
       
        return dateString
    }
   }


extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
      
        //on other screens do same as far as reading user default adn then setting background and logo
        UserDefaults.standard.set(settingsData.skins[row], forKey: "SkinLogo")
        settingsData.refreshSettings()
        pickerView.isHidden = true;
        
        switch settingsData.skinLogo {
        case "Evergreen":
            let logo = settingsData.skinEvergreen
            butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorEvergreen
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorEvergreen
           
            
        case "University Prep":
            let logo = settingsData.skinUniversityPrep
            butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorUniversityPrep
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorUniversityPrep
            
        case "Neutral":
            let logo = settingsData.skinNeutral
            self.butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorNeutral
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorNeutral
           
            
        default:
            let logo = settingsData.skinLakeside
            butLogo.setImage(UIImage(named: logo), for: .normal)
            self.view.backgroundColor = settingsData.swiftColorLakeside
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorLakeside
            
            
        }  //endswitch
        setBackgrounds()
        
        self.view.layoutIfNeeded()
        
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   
        return settingsData.skins[row]
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingsData.skins.count
        
    }
    
    
    
    
    
}

extension ViewController {
    
}

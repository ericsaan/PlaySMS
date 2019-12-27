//
//  PDFAfternoon.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/8/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit
import MessageUI


//says afternoon but really is morning, just too lazy to change it
class PDFAfternoon: UIViewController, MFMessageComposeViewControllerDelegate

{

    
    
    @IBOutlet var viewMorning: UIView!
    @IBOutlet weak var PDF_ViewMorning: UIWebView!
    
    var settingsData = Settings()
    
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
        //load up the Afternoon PDF File
        
      //  let path = Bundle.main.path(forResource: "LakesideCustomBusSchedules-2018-2019 Morning", ofType: "pdf")!
        let path = Bundle.main.path(forResource: "MetroCustomBusSchedule2019-2020 Morning", ofType: "pdf")!

    
        settingsData.refreshSettings()
        setBackgrounds()
        
        let targetURL = URL(fileURLWithPath: path)
        let request = URLRequest(url: targetURL)
        PDF_ViewMorning.loadRequest(request)
        
        
    }
    func setBackgrounds() {
        settingsData.refreshSettings()
        switch settingsData.skinLogo {
        case "Evergreen":
            self.PDF_ViewMorning.backgroundColor = settingsData.swiftColorEvergreen
            self.viewMorning.backgroundColor = settingsData.swiftColorEvergreen
            self.view.backgroundColor = settingsData.swiftColorEvergreen
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorEvergreen
            
        case "University Prep":
            self.PDF_ViewMorning.backgroundColor = settingsData.swiftColorUniversityPrep
            self.viewMorning.backgroundColor = settingsData.swiftColorUniversityPrep
            self.view.backgroundColor = settingsData.swiftColorUniversityPrep
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorUniversityPrep
            
        case "Neutral":
            self.PDF_ViewMorning.backgroundColor = settingsData.swiftColorNeutral
            self.viewMorning.backgroundColor = settingsData.swiftColorNeutral
            self.view.backgroundColor =  UIColor.black // settingsData.swiftColorNeutral
            self.tabBarController?.tabBar.barTintColor = UIColor.black  //  settingsData.swiftColorNeutral
            
        default:  //as in Lakeside
            self.PDF_ViewMorning.backgroundColor = settingsData.swiftColorLakeside
            self.viewMorning.backgroundColor = settingsData.swiftColorLakeside
            self.view.backgroundColor = settingsData.swiftColorLakeside
            self.tabBarController?.tabBar.barTintColor = settingsData.swiftColorLakeside
            
        }  //endswitch
        self.view.layoutIfNeeded()
    }  //endsetbackground
    
}

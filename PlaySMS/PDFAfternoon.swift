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

    
    
    @IBOutlet weak var PDF_ViewMorning: UIWebView!
    
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
        
        let path = Bundle.main.path(forResource: "FinalLakesideCustomBus-AM_Schedule-2017-18", ofType: "pdf")!
        
        let targetURL = URL(fileURLWithPath: path)
        let request = URLRequest(url: targetURL)
        PDF_ViewMorning.loadRequest(request)
        
        
    }
    
}

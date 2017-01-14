//
//  ViewController_PDFViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/7/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit
import MessageUI

class ViewController_PDFViewController: UIViewController, MFMessageComposeViewControllerDelegate
{

    
    
    @IBOutlet weak var PDF_Webview: UIWebView!
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        //load up the Afternoon PDF File
        
        let path = Bundle.main.path(forResource: "2016-17PMScheduleEffective9-12-16", ofType: "pdf")!
        
        let targetURL = URL(fileURLWithPath: path)
        let request = URLRequest(url: targetURL)
        PDF_Webview.loadRequest(request)
        
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //load up the PDF File
        
        
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

//
//  ViewController_WheresTheBusViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/15/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit
import MessageUI

class ViewController_WheresTheBusViewController: UIViewController, MFMessageComposeViewControllerDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
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

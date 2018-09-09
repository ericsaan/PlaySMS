//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    var settingsData = Settings()

    @IBOutlet var messageBackground: UIView!

    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    @IBOutlet weak var cellMessage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
//        settingsData.refreshSettings()
//        
//        if settingsData.skinLogo != settingsData.skinLakeside
//        {
//            messageBackground.backgroundColor = UIColor.white
//        }
//        
        
    }


}

//
//  CustomMessageCell.swift
//  borrowsed from udemy class

import UIKit

class CustomMessageCell: UITableViewCell {

    var settingsData = Settings()

    @IBOutlet var messageBackground: UIView!

    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    @IBOutlet weak var cellMessage: UIView!
    override func awakeFromNib() {
    super.awakeFromNib()
       
        
    }


}

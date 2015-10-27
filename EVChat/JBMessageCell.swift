//
//  JBMessageCell.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-26.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import Parse
import JSQMessagesViewController

class JBMessageCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    func bindData(message: PFObject) {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.layer.masksToBounds = true
        
        let lastUser = message["lastUser"] as? PFUser
        userImage.image = UIImage(named: "noneprofile.png")
        
        descriptionLabel.text = message["description"] as? String
        lastMessageLabel.text = message["lastMessage"] as? String
        
        let seconds = NSDate().timeIntervalSinceDate(message["updatedAction"] as! NSDate)
        timeElapsedLabel.text = MessageAction.timeElapsed(seconds)
        let dateText = JSQMessagesTimestampFormatter.sharedFormatter().relativeDateForDate(message["updatedAction"] as? NSDate)
        if dateText == "Today" {
            timeElapsedLabel.text = JSQMessagesTimestampFormatter.sharedFormatter().timeForDate(message["updatedAction"] as? NSDate)
        } else {
            timeElapsedLabel.text = dateText
        }
        
        let counter = message["counter"]!.integerValue
        counterLabel.text = (counter == 0) ? "" : "\(counter) new"
    }
}

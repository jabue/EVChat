//
//  MessageAction.swift
//  EVChat
//
//  Created by Kris Yang on 2015-09-20.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class MessageAction {
    
    // generate chat ID
    class func startMultipleChat(users: [PFUser]!) -> String {
        var groupId = ""
        var description = ""
        
        var userIds = [String]()
        
        for user in users {
            userIds.append(user.objectId!)
        }
        
        let sorted = userIds.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
        for userId in sorted {
            groupId = groupId + userId
        }
        
        for user in users {
            if description.characters.count > 0 {
                description = description + " & "
            }
            description = description + (user["username"] as! String)
        }
        
        // description = description + "&" + (PFUser.currentUser()?.username)!
        if users.count == 2 {
            let user1 = users[0]
            let user2 = users[1]
            MessageAction.createMessageItem(user1, groupId: groupId, description: user2.username!)
            MessageAction.createMessageItem(user2, groupId: groupId, description: user1.username!)
        } else {
            for user in users {
                MessageAction.createMessageItem(user, groupId: groupId, description: description)
            }
        }
        // MessageAction.createMessageItem(PFUser.currentUser()!, groupId: groupId, description: description)
        
        return groupId
    }
    
    // create message chart
    class func createMessageItem(user: PFUser, groupId: String, description: String) {
        let query = PFQuery(className: "Messages")
        query.whereKey("user", equalTo: user)
        query.whereKey("groupId", equalTo: groupId)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    let message = PFObject(className: "Messages")
                    message["user"] = user;
                    message["groupId"] = groupId;
                    message["description"] = description;
                    message["lastUser"] = PFUser.currentUser()
                    message["lastMessage"] = "";
                    message["counter"] = 0
                    message["updatedAction"] = NSDate()
                    message.saveInBackgroundWithBlock({ (returnedResult, returnedError) -> Void in
                        if (returnedError != nil) {
                            print("Messages.createMessageItem save error.")
                            print(error)
                        }
                    })
                }
            } else {
                print("Messages.createMessageItem save error.")
                print(error)
            }
        }
    }
    
    // data stamp
    class func timeElapsed(seconds: NSTimeInterval) -> String {
        var elapsed: String
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            let suffix = (minutes > 1) ? "mins" : "min"
            elapsed = "\(minutes) \(suffix) ago"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            let suffix = (hours > 1) ? "hours" : "hour"
            elapsed = "\(hours) \(suffix) ago"
        }
        else {
            let days = Int(seconds / (24 * 60 * 60))
            let suffix = (days > 1) ? "days" : "day"
            elapsed = "\(days) \(suffix) ago"
        }
        return elapsed
    }

}
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
        
        for user in users {
            MessageAction.createMessageItem(user, groupId: groupId, description: description)
        }
        
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
                    message.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                        if (error != nil) {
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

}
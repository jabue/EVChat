//
//  UserAction.swift
//  EVChat
//
//  Created by Kris Yang on 2015-09-20.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import Foundation
import Parse

class UserAction {
    
    // user signup function
    class func userSignup(username: String, password: String, email: String) {
        // create parse user object
        var user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        // add extra info of user
        user["phone"] = "778-334-0000"
        user.signUpInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil {
                print("user:" + "\(username)" + " sign up successfully!")
                // user signup successfully, push notification
                // PushNotication.parsePushUserAssign()
            } else {
                print("sign up failed, please try again!")
                // signup fail
                
            }
        }
    }
    
    // user login function
    class func userLogin(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (returnedResult, returnedError) -> Void in
            if returnedError == nil {
                print("user:" + "\(username)" + " is login!")
                // user online successfully, push notification
                // PushNotication.parsePushUserAssign()
            } else {
                print("login failed, please try again!")
                // user login failed
            }
        }
    }
    
    // user logout function
    class func userLogout() {
        PFUser.logOut()
    }
}

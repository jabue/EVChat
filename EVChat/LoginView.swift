//
//  LoginView.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-29.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // blink click returns
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // when text field touched, view move up
    func textFieldDidBeginEditing(textField: UITextField) {
        // animateViewMoving(true, moveValue: 100)
    }
    // view move down
    func textFieldDidEndEditing(textField: UITextField) {
        // animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.1
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    // button actions
    @IBAction func signinAction(sender: UIButton) {
        let username = userTxt.text?.lowercaseString
        let password = passwordTxt.text
        
        if username == "" {
            infoLabel.text = "username cannot be null!"
            return
        }
        if password == "" {
            infoLabel.text = "password cannot be null!"
            return
        }
        
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (returnedResult, returnedError) -> Void in
            if returnedError == nil {
                print("user:" + "\(username)" + " is login!")
                // user online successfully, push notification
                // PushNotication.parsePushUserAssign()
                self.performSegueWithIdentifier("loginsuccess", sender: self)
                
            } else {
                print("login failed, please try again!")
                // user login failed
                self.userTxt.text = ""
                self.passwordTxt.text = ""
                self.infoLabel.text = "Wrong username or passowrd!"
            }
        }
    }
    
}

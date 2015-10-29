//
//  Welcome.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-29.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Welcome: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // if user is logged in already, then direct to the main view
        if PFUser.currentUser() != nil {
            // go to different views depends on the segmented choice
            dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("autologin", sender: self)
            });
        // go to login view, let user to login in
        } else {
            dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("login", sender: self)});
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  JBProfile.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-27.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit

class JBProfile: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // change photo cell
        if (indexPath.section == 0 && indexPath.row == 0) {
            print("change photo")
        // chat id
        }else if (indexPath.section == 1 && indexPath.row == 0) {
         
        // email address
        }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        // phone number
        }else if (indexPath.section == 1 && indexPath.row == 2) {
         
        // log out
        }else if (indexPath.section == 2 && indexPath.row == 0) {
            
        }
    }
}

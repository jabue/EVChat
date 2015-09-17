//
//  MessageViewController.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-16.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var BtnReturn: UIBarButtonItem!
    var groupId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationBar.title = "Here to Chat"
        print(groupId)
        // Do any additional setup after loading the view, typically from a nib.
        // ChatTable setup
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.senderId = "Jabue"
        self.senderDisplayName = "Jabue Chat"
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func btnReturnPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

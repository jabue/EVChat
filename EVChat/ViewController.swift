//
//  ViewController.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-10.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Parse

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddFriendsDelegate {

    @IBOutlet weak var BtnEdit: UIButton!
    @IBOutlet weak var ChatTable: UITableView!
    @IBOutlet weak var InsideTable: UITableView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    @IBOutlet var SwipeRight: UISwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: UISwipeGestureRecognizer!
    @IBOutlet weak var AddButton: UIButton!
    // chat queue
    // var ChatArray = ["Jabue"]
    var messages = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ChatTable setup
        ChatTable.delegate = self
        ChatTable.dataSource = self
        // set up table display
        ChatTable.hidden = false
        InsideTable.hidden = true
        
        // here to login or sign up user for chat test
        // UserAction.userSignup("kris", password: "kris", email: "test@gmail.com")
        // UserAction.userLogin("kris", password: "kris")
        
        // loadMessages from server
        if PFUser.currentUser() != nil {
            self.loadMessages()
        } else {
            print("User is logout, please login !")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark: Segmented Controller
    @IBAction func SegmentSwitch(sender: UISegmentedControl) {
        switch SegmentControl.selectedSegmentIndex
        {
        case 0:
            // self.ChatContainer.hidden = true
            // self.InsideContainer.hidden = false
            self.ChatTable.hidden = false
            self.InsideTable.hidden = true
        case 1:
            // self.ChatContainer.hidden = false
            // self.InsideContainer.hidden = true
            self.ChatTable.hidden = true
            self.InsideTable.hidden = false
        default:
            break; 
        }
    }
    
    // MARK: - Backend methods
    func loadMessages() {
        let query = PFQuery(className: "Messages")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        print(PFUser.currentUser())
        query.includeKey("lastUser")
        query.orderByDescending("updatedAction")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.messages.removeAll(keepCapacity: false)
                self.messages += objects as! [PFObject]!
                self.ChatTable.reloadData()
            } else {
                print("fail to load all the messages !")
            }
        }
    }
    
    // Mark: Swipe gesture
    @IBAction func swipeRight(sender: AnyObject) {
        // self.ChatContainer.hidden = true
        // self.InsideContainer.hidden = false
        self.ChatTable.hidden = false
        self.InsideTable.hidden = true
        SegmentControl.selectedSegmentIndex = 0
    }
    
    @IBAction func swipeLeft(sender: AnyObject) {
        self.ChatTable.hidden = true
        self.InsideTable.hidden = false
        // self.ChatContainer.hidden = false
        // self.InsideContainer.hidden = true
        SegmentControl.selectedSegmentIndex = 1
    }
    
    // Mark: add button action
    @IBAction func addButtonAction(sender: AnyObject) {
        // go to different views depends on the segmented choice
        if SegmentControl.selectedSegmentIndex == 0
        {
            self.performSegueWithIdentifier("SelectFriends", sender: self)
        }
        else
        {
            self.performSegueWithIdentifier("PushInsides", sender: self)
        }
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        // return friendsArray.count
        // print("Chat Array Length:" +  "\(self.ChatArray.count)")
        // return self.ChatArray.count
        return self.messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // make sections of the table
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! UITableViewCell
        let message = messages[indexPath.row]
        // deal with the description String
        // var description = message["description"] as! String
        // let userName = PFUser.currentUser()?.username
        // description.rangeOfString(username)
        cell.textLabel?.text = message["description"] as! String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // open chat selected
        // let chatuser = self.ChatArray[indexPath.row]
        let message = self.messages[indexPath.row] as PFObject
        let groupId = message["groupId"] as! String
        self.performSegueWithIdentifier("OpenChat", sender: groupId)
    }
    
    // MARK: - SelectMultipleDelegate
    // select friends gonna chat with
    func didSelectMultipleUsers(selectedUsers: [PFUser]!) {
        let groupId = MessageAction.startMultipleChat(selectedUsers)
        self.loadMessages()
        self.ChatTable.reloadData()
        self.performSegueWithIdentifier("OpenChat", sender: groupId)
    }
    
    // MARK: - Prepare for segue to chatVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectFriends" {
            let addFriends = segue.destinationViewController as! AddFriends
            // set up the delegate
            addFriends.delegate =  self
        }
        else if segue.identifier == "OpenChat" {
            // do some setuo for the Chat view
            let nav = segue.destinationViewController as! UINavigationController
            let ChatView = nav.topViewController as! MessageViewController

            let groupId = sender as! String
            ChatView.groupId = groupId
        }
        
    }

    @IBAction func btnEditPressed(sender: AnyObject) {
        
    }
}


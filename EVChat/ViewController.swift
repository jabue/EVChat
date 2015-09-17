//
//  ViewController.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-10.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddFriendsDelegate {

    @IBOutlet weak var BtnEdit: UIButton!
    @IBOutlet weak var ChatTable: UITableView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    @IBOutlet var SwipeRight: UISwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: UISwipeGestureRecognizer!
    @IBOutlet weak var AddButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // ChatTable setup
        ChatTable.delegate = self
        ChatTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark: Segmented Controller
    @IBAction func SegmentSwitch(sender: UISegmentedControl) {
        switch SegmentControl.selectedSegmentIndex
        {
        case 0: break
            // self.ChatContainer.hidden = true
            // self.InsideContainer.hidden = false
        case 1: break
            // self.ChatContainer.hidden = false
            // self.InsideContainer.hidden = true
        default:
            break; 
        }
    }
    
    // Mark: Swipe gesture
    @IBAction func swipeRight(sender: AnyObject) {
        // self.ChatContainer.hidden = true
        // self.InsideContainer.hidden = false
        SegmentControl.selectedSegmentIndex = 0
    }
    
    @IBAction func swipeLeft(sender: AnyObject) {
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
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FriendCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! UITableViewCell
        // cell.textLabel?.text = friendsArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
    }
    
    // MARK: - SelectMultipleDelegate
    func didSelectMultipleUsers(selectedUsers: [String]!) {
        self.performSegueWithIdentifier("OpenChat", sender: "haha")
        // self.performSegueWithIdentifier("OpenChat", sender: <#T##AnyObject?#>)
        print(selectedUsers)
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


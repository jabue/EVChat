//
//  JBChatMainView.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-19.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//
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

class JBChatMainView: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, AddFriendsDelegate {
    
    @IBOutlet weak var ChatTable: UITableView!
    @IBOutlet var SwipeRight: UISwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: UISwipeGestureRecognizer!
    @IBOutlet weak var AddButton: UIButton!
    
    // chat queue, table data source
    var messages = [PFObject]()
    var filteredMessage = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // loadMessages from server
        if PFUser.currentUser() != nil {
            self.loadMessages()
        } else {
            print("user is not login !")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    @IBAction func swipeLeft(sender: AnyObject) {
    }
    
    // Mark: add button action
    @IBAction func addButtonAction(sender: AnyObject) {
        // go to different views depends on the segmented choice
        self.performSegueWithIdentifier("SelectFriends", sender: self)
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if (ChatTable == self.searchDisplayController?.searchResultsTableView)
        {
            return self.filteredMessage.count
        }
        else
        {
            return self.messages.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // make sections of the table
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ChatCells")! as UITableViewCell
        
        var message: PFObject
        if (ChatTable == self.searchDisplayController?.searchResultsTableView)
        {
            message = filteredMessage[indexPath.row]
        }
        else
        {
            message = messages[indexPath.row]
        }
        cell.textLabel?.text = message["description"] as! String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // open chat selected
        // let chatuser = self.ChatArray[indexPath.row]
        // let message = self.messages[indexPath.row] as PFObject
        var message: PFObject
        if (ChatTable == self.searchDisplayController?.searchResultsTableView)
        {
            message = filteredMessage[indexPath.row]
        }
        else
        {
            message = messages[indexPath.row]
        }
        let groupId = message["groupId"] as! String
        self.performSegueWithIdentifier("OpenChat", sender: groupId)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [share, favorite, more]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    // MARK: - SelectMultipleDelegate
    // select friends gonna chat with
    func didSelectMultipleUsers(selectedUsers: [PFUser]!) {
        let groupId = MessageAction.startMultipleChat(selectedUsers)
        self.loadMessages()
        // self.ChatTable.reloadData()
        self.performSegueWithIdentifier("OpenChat", sender: groupId)
    }
    
    // MARK: search
    // function used to filter search string
    func filterContentForSearchText(searchText: String, scope: String = "Title") {
        // Filter the array using the filter method
        self.filteredMessage = self.messages.filter({( msg: PFObject) -> Bool in
            let msgName = msg["description"] as! String
            let stringMatch = msgName.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!, scope: "Title")
        return true
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


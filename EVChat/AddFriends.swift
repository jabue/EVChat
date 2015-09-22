//
//  AddFriends.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-14.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import Parse

protocol AddFriendsDelegate {
    func didSelectMultipleUsers(selectedUsers: [PFUser]!)
}

class AddFriends: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var BtnDone: UIButton!
    @IBOutlet weak var BtnCancel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var delegate: AddFriendsDelegate!
    
    // PFUsers Array
    var users = [PFUser]()
    // used to put selected item
    var selectedFriends = [PFUser]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the delegate & datasource of tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // load chat user friends
        self.loadUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Backend methods
    func loadUsers() {
        let user = PFUser.currentUser()
        let query = PFUser.query()
        query!.whereKey("objectId", notEqualTo: user!.objectId!)
        query!.orderByAscending("username")
        query!.limit = 1000
        query!.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return users.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FriendCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! UITableViewCell
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user["username"] as? String
        // cell.textLabel?.text = friendsArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.selected
        {
            if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark
            {
                // selectedFriends.removeAtIndex(selectedFriends.indexOf((cell?.textLabel?.text)!)!)
                selectedFriends.removeAtIndex(selectedFriends.indexOf(users[indexPath.row])!)
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
            else
            {
                // let selectedUser = self.users[indexPath.row]
                // selectedFriends.append((selectedUser["username"] as? String)!)
                selectedFriends.append(self.users[indexPath.row])
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        }
        else
        {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    //MARK: Button Action
    @IBAction func BtnCancelAction(sender: AnyObject) {
        // dismiss the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnDonePress(sender: AnyObject) {
        // none is selected
        if selectedFriends.count == 0
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                // pass the selectedfriends to next view through delegate
                self.selectedFriends.append(PFUser.currentUser()!)
                self.delegate.didSelectMultipleUsers(self.selectedFriends)
            })
        }
    }
    
    
}
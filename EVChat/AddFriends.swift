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

class AddFriends: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate
{
    
    @IBOutlet weak var BtnDone: UIButton!
    @IBOutlet weak var BtnCancel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var delegate: AddFriendsDelegate!
    
    // PFUsers Array
    var users = [PFUser]()
    var filteredUsers = [PFUser]()
    // used to put selected item
    var selectedFriends = [PFUser]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load chat user friends
        if PFUser.currentUser() != nil {
            self.loadUsers()
        } else {
            print("user is not login !")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Backend methods
    // load users from parse server
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
        // if is in the search status
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return filteredUsers.count
        }
        else
        {
           return users.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FriendCell")
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! UITableViewCell
        var user: PFUser
        // if is in the search status
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            user = self.filteredUsers[indexPath.row]
        }
        else
        {
            user = self.users[indexPath.row]
        }
        cell.textLabel?.text = user["username"] as? String
        
        // someone is already selected, add the mark
        if(selectedFriends.contains(user)){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // if is in the search status
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            
            if cell!.selected
            {
                if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark
                {
                    selectedFriends.removeAtIndex(selectedFriends.indexOf(filteredUsers[indexPath.row])!)
                    self.tableView.reloadData()
                }
                else
                {
                    selectedFriends.append(filteredUsers[indexPath.row])
                    self.tableView.reloadData()
                }
                self.searchDisplayController?.active = false
            }
        }
        else
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            
            if cell!.selected
            {
                if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark
                {
                    selectedFriends.removeAtIndex(selectedFriends.indexOf(users[indexPath.row])!)
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
                else
                {
                    selectedFriends.append(users[indexPath.row])
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                
            }
        }
    }
    
    // MARK: search
    // function used to filter search string
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredUsers = self.users.filter({( user: PFUser) -> Bool in
            let userName = user["username"] as! String
            let stringMatch = userName.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
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
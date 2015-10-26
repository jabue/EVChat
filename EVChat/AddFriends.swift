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
    // used to hold search reasult
    var filteredUsers = [PFUser]()
    // used to put selected item
    var selectedFriends = [PFUser]()
    // raw user data, used to make sections for the table
    var userNames = [String]()
    // used to make connections for names and PFUsers
    var userNameToPF = [String: PFUser]()
    
    
    // user structure, used to make sections for tableView
    class User: NSObject {
        let name: String
        var section: Int?
        
        init(name: String) {
            self.name = name
        }
    }
    
    // sections structure, used to make sections for tableView
    class Section {
        var users: [User] = []
        
        func addUser(user: User) {
            self.users.append(user)
        }
    }
    
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
                self.userNames.removeAll(keepCapacity: false)
                self.userNameToPF.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                // init userName Array
                for user in self.users {
                    self.userNames.append(user["username"] as! String)
                    self.userNameToPF[user["username"] as! String] = user
                }
                self.sections = self.fillSections()
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    // UIKit convenience class for sectioning a table
    let collation = UILocalizedIndexedCollation.currentCollation()
        as UILocalizedIndexedCollation
    
    var _sections: [Section]?
    
    // table sections
    var sections = [Section]()
    
    // function used to init sections
    func fillSections() -> [Section]{
        // return if already initialized
        if self._sections != nil {
            return self._sections!
        }
        
        // create users from the name list
        var users: [User] = userNames.map { name in
            var user = User(name: name)
            user.section = self.collation.sectionForObject(user, collationStringSelector: "name")
            return user
        }
        
        // create empty sections
        var sections = [Section]()
        for i in 0..<self.collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // put each user in a section
        for user in users {
            sections[user.section!].addUser(user)
        }
        
        // sort each section
        for section in sections {
            section.users = self.collation.sortedArrayFromArray(section.users, collationStringSelector: "name") as! [User]
        }
        
        self._sections = sections
        
        return self._sections!
        
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
           return self.sections[section].users.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return 1
        }
        else
        {
            return self.sections.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell")!
        var user: PFUser
        // if is in the search status
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            user = self.filteredUsers[indexPath.row]
        }
        else
        {
            let temp = self.sections[indexPath.section].users[indexPath.row]
            user = userNameToPF[temp.name]!
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
                let user = filteredUsers[indexPath.row]
                if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark
                {
                    selectedFriends.removeAtIndex(selectedFriends.indexOf(user)!)
                    self.tableView.reloadData()
                }
                else
                {
                    selectedFriends.append(user)
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
                let temp = self.sections[indexPath.section].users[indexPath.row]
                let user = userNameToPF[temp.name]!
                if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark
                {
                    selectedFriends.removeAtIndex(selectedFriends.indexOf(user)!)
                    cell!.accessoryType = UITableViewCellAccessoryType.None
                }
                else
                {
                    selectedFriends.append(user)
                    cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                
            }
        }
    }
    
    // section headers
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)
        -> String {
            if(tableView == self.searchDisplayController?.searchResultsTableView)
            {
                return ""
            }
            // do not display empty `Section`s
            if !self.sections[section].users.isEmpty {
                return self.collation.sectionTitles[section] as String
            }
            return ""
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return []
        }
        return self.collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String,
        atIndex index: Int)
        -> Int {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
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
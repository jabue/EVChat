//
//  JBContactList.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-23.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import Parse

class JBContactList: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    // PFUsers, used to store PFusers get from remote server
    var users = [PFUser]()
    // used to hold search reasult
    var filteredUsers = [PFUser]()
    // raw user data, used to make sections for the table
    var userNames = [String]()
    // used to make connections for names and PFUsers
    var userNameToPF = [String: PFUser]()
    // used to put selected item
    var selectedFriends = [PFUser]()
    
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

    // override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load chat user friends
        if PFUser.currentUser() != nil {
            self.loadUsers()
        } else {
            print("user is not login !")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // table view data source
    func numberOfSectionsInTableView(tableView: UITableView)
        -> Int {
            if(tableView == self.searchDisplayController?.searchResultsTableView)
            {
                return 1
            }
            else
            {
                return self.sections.count
            }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            if(tableView == self.searchDisplayController?.searchResultsTableView)
            {
                return filteredUsers.count
            }
            else
            {
                return self.sections[section].users.count
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
            var user: PFUser
            if(tableView == self.searchDisplayController?.searchResultsTableView)
            {
               user = filteredUsers[indexPath.row]
            }
            else
            {
                let temp = self.sections[indexPath.section].users[indexPath.row]
                user = userNameToPF[temp.name]!
            }
            
            cell.textLabel!.text = user["username"] as? String
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var user: PFUser
        if(tableView == self.searchDisplayController?.searchResultsTableView)
        {
            user = filteredUsers[indexPath.row]
        }
        else
        {
            let temp = self.sections[indexPath.section].users[indexPath.row]
            user = userNameToPF[temp.name]!
        }
        // put selected use in selectedFriends Array
        selectedFriends.removeAll(keepCapacity: false)
        selectedFriends.append(user)
        selectedFriends.append(PFUser.currentUser()!)
        // cancel search action
        self.searchDisplayController!.active = false
        
        let groupId = MessageAction.startMultipleChat(selectedFriends)
        self.performSegueWithIdentifier("openchat", sender: groupId)
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
    
    // MARK: - Prepare for segue to chatVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openchat" {
            // do some setup for the Chat view
            let nav = segue.destinationViewController as! UINavigationController
            let ChatView = nav.topViewController as! MessageViewController
            
            let groupId = sender as! String
            ChatView.groupId = groupId
        }
        
    }
}
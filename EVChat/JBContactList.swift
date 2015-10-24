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
    // PFUsers Array
    var users = [PFUser]()
    
    // user structure
    class User: NSObject {
        let name: String
        var section: Int?
        
        init(name: String) {
            self.name = name
        }
    }
    
    // custom type to represent table sections
    class Section {
        var users: [User] = []
        
        func addUser(user: User) {
            self.users.append(user)
        }
    }
    
    // raw user data
    var userNames = [String]()
    let names = [
        "Clementine",
        "Bessie",
        "Yolande",
        "Tynisha",
        "Ellyn",
        "Trudy",
        "Fredrick",
        "Letisha",
        "Ariel",
        "Bong",
        "Jacinto",
        "Dorinda",
        "Aiko",
        "Loma",
        "Augustina",
        "Margarita",
        "Jesenia",
        "Kellee",
        "Annis",
        "Charlena"
    ]
    
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
                self.users += objects as! [PFUser]!
                // init userName Array
                for user in self.users {
                    self.userNames.append(user["username"] as! String)
                }
                self.sections = self.fillSections()
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    // `UIKit` convenience class for sectioning a table
    let collation = UILocalizedIndexedCollation.currentCollation()
        as UILocalizedIndexedCollation
    
    var _sections: [Section]?
    
    // table sections
    var sections = [Section]()
    
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
            return self.sections.count
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            return self.sections[section].users.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let user = self.sections[indexPath.section].users[indexPath.row]
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = user.name
            return cell
    }
    
    /* section headers
    appear above each `UITableView` section */
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            // do not display empty `Section`s
            if !self.sections[section].users.isEmpty {
                return self.collation.sectionTitles[section] as String
            }
            return ""
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView,
        sectionForSectionIndexTitle title: String,
        atIndex index: Int)
        -> Int {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
    }
}
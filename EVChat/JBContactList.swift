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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // `UIKit` convenience class for sectioning a table
    let collation = UILocalizedIndexedCollation.currentCollation()
        as UILocalizedIndexedCollation
    
    var _sections: [Section]?
    
    // table sections
    var sections: [Section] {
        // return if already initialized
        if self._sections != nil {
            return self._sections!
        }
        
        // create users from the name list
        var users: [User] = names.map { name in
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
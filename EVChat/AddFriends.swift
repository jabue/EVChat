//
//  AddFriends.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-14.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit

class AddFriends: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var BtnCancel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // test friends Array
    var friendsArray = ["Kris", "Jabue", "Tom"]
    // used to put selected item
    var selectedFriends = [String]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return friendsArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FriendCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = friendsArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell!.selected
        {
            if cell!.accessoryType == UITableViewCellAccessoryType.Checkmark
            {
                selectedFriends.removeAtIndex(selectedFriends.indexOf((cell?.textLabel?.text)!)!)
                cell!.accessoryType = UITableViewCellAccessoryType.None
            }
            else
            {
                selectedFriends.append(friendsArray[indexPath.row])
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        }
        else
        {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    //MARK: Cancel Button
    @IBAction func BtnCancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
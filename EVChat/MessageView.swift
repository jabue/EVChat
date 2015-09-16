//
//  MessageView.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-15.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit

class MessageView: UIViewController, UITableViewDelegate, UITableViewDataSource, JSQMessagesViewController
{
    
    @IBOutlet weak var BtnReturn: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the delegate & datasource of tableView
        // tableView.delegate = self
        // tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        // let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "FriendCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! UITableViewCell
        // cell.textLabel?.text = friendsArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
    }
    
    //MARK: Button Action
    @IBAction func btnReturnPress(sender: AnyObject) {
        // dismiss the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//
//  MessageViewController.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-16.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import Parse
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var BtnReturn: UIBarButtonItem!
    
    var groupId: String = ""
    // User Array
    var users = [PFUser]()
    // Message Array
    var messages = [JSQMessage]()
    // chat bubble
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    // user Image
    var blankAvatarImage: JSQMessagesAvatarImage!
    // token to load messages
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        self.senderId = user?.objectId
        self.senderDisplayName = user?.username
        
        NavigationBar.title = "chat view"
        print(groupId)
        
        // chat and user image used in this view
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "profile_blank"), diameter: 30)
        
        // load chat messages
        isLoading = false
        // self.loadMessages()
        if PFUser.currentUser() != nil {
            self.loadMessages()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // these two must not be nil
        // self.senderId = "Jabue"
        // self.senderDisplayName = "Jabue Chat"
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //MARK: Background Functions
    func loadMessages() {
        if self.isLoading == false {
            self.isLoading = true
            var lastMessage = messages.last
            
            var query = PFQuery(className: "Chat")
            query.whereKey("groupId", equalTo: groupId)
            if lastMessage != nil {
                query.whereKey("createdAt", greaterThan: (lastMessage?.date)!)
            }
            query.includeKey("user")
            query.orderByDescending("createdAt")
            query.limit = 5
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.automaticallyScrollsToMostRecentMessage = false
                    for object in (objects as! [PFObject]!).reverse() {
                        self.addMessage(object)
                    }
                    if objects!.count > 0 {
                        self.finishReceivingMessage()
                        self.scrollToBottomAnimated(false)
                    }
                    self.automaticallyScrollsToMostRecentMessage = true
                } else {
                    print("Load Message Wrong !")
                }
                self.isLoading = false;
            })
        }
    }
    
    // add message to table data source
    func addMessage(object: PFObject) {
        var message: JSQMessage!
        
        var user = object["user"] as! PFUser
        var name = user["username"] as! String
        
        message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, text: (object["text"] as? String))
        
        users.append(user)
        messages.append(message)
    }
    
    // send message func
    func sendMessage(var text: String) {
        
        // add chat to server
        var object = PFObject(className: "Chat")
        object["user"] = PFUser.currentUser()
        object["groupId"] = self.groupId
        object["text"] = text
        object.saveInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil {
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.loadMessages()
            } else {
                print("Failed to send message !")
            }
        }
        // add last message to server
        var query = PFQuery(className:"Messages")
        query.whereKey("groupId", equalTo: groupId)
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in (objects as! [PFObject]!) {
                    object["lastMessage"] = text
                    object.saveInBackground()
                }
            } else {
                print("Load Message Wrong !")
            }
            self.isLoading = false;
        })
        
        self.finishSendingMessage()
    }
    
    // MARK: - JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        self.sendMessage(text)
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Accessory Button pressed !")
    }
    
    // MARK: - JSQMessages CollectionView
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.messages[indexPath.row]
        if (data.senderId == self.senderId) {
            return self.outgoingBubbleImage
        } else {
            return self.incomingBubbleImage
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return blankAvatarImage
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    //MARK: Button Action
    @IBAction func btnReturnPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

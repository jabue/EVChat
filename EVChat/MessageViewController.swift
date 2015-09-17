//
//  MessageViewController.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-16.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessageViewController: JSQMessagesViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var BtnReturn: UIBarButtonItem!
    
    var groupId: String = ""
    // Message Array
    var messages = [JSQMessage]()
    // chat bubble
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    // user Image
    var blankAvatarImage: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "Jabue"
        self.senderDisplayName = "Jabue Chat"
        
        NavigationBar.title = "Here to Chat"
        print(groupId)
        
        // chat and user image used in this view
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "profile_blank"), diameter: 30)
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
    func sendMessage(var text: String, video: NSURL?, picture: UIImage?) {
        var newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text);
        messages += [newMessage]
        self.finishSendingMessage()
    }
    
    // MARK: - JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        self.sendMessage(text, video: nil, picture: nil)
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

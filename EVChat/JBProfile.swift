//
//  JBProfile.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-27.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit
import Parse

class JBProfile: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var selfPhoto: UIImageView!
    // photo taking
    var photoTaker: UIImagePickerController!
    var photoTemp: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: tableview func
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // change photo cell
        if (indexPath.section == 0 && indexPath.row == 0) {
            let actionSheetController: UIAlertController = UIAlertController(title: "Change Photo", message: "Please choose from one of the following options", preferredStyle: .ActionSheet)
            
            // add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            
            // add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Take A Picture", style: .Default) { action -> Void in
                //Code for launching the camera goes here
                
                self.photoTaker = UIImagePickerController()
                self.photoTaker.delegate = self
                self.photoTaker.sourceType = .Camera
                
                self.presentViewController(self.photoTaker, animated: true, completion: nil)
                
            }
            actionSheetController.addAction(takePictureAction)
            // add a second option action
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "From the Gallery", style: .Default) { action -> Void in
                //Code for picking from camera roll goes here
            }
            actionSheetController.addAction(choosePictureAction)
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        // chat id
        }else if (indexPath.section == 1 && indexPath.row == 0) {
         
        // email address
        }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        // phone number
        }else if (indexPath.section == 1 && indexPath.row == 2) {
         
        // log out
        }else if (indexPath.section == 2 && indexPath.row == 0) {
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Mark: backend func
    // func for redirecting a camera
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        photoTaker.dismissViewControllerAnimated(true, completion: nil)
        self.photoTemp = info[UIImagePickerControllerOriginalImage] as! UIImage
        if photoTemp.size.width > 280 {
            photoTemp = Image.resizeImage(photoTemp, width: 280, height: 280)!
        }
        
        // put it to PFFile, get prepared before store to server
        var pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(photoTemp, 0.6)!)
//        pictureFile.saveInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
//            if returnedError != nil {
//                print("store picture.jpg fail.")
//            }
//        }
        
        // pass photo to imageView
        self.selfPhoto.image = self.photoTemp
        
        if photoTemp.size.width > 60 {
            photoTemp = Image.resizeImage(photoTemp, width: 60, height: 60)!
        }
        // generate thumbnail picture of user
        var thumbnailFile = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(photoTemp, 0.6)!)
        var user : PFUser = PFUser.currentUser()!
        user["picture"] = pictureFile
        user["thumbnail"] = thumbnailFile
        user.saveInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError != nil {
                print("store both picture fail")
            }
        }
        
        tableView.reloadData()
    }
}

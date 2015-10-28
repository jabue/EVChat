//
//  JBProfile.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-10-27.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit

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
        print("Camera off...")
        self.photoTemp = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.selfPhoto.image = self.photoTemp
        
        // set photo to upload url
        // let testFileURL1 = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("temp"))
        // let uploadRequest1: AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        
        // let data = UIImageJPEGRepresentation(self.selfPhoto, 0.2)
        // data?.writeToURL(testFileURL1, atomically: true)
        // uploadRequest1.bucket = "sefietest"
        // uploadRequest1.key = "test1"
        // uploadRequest1.body = testFileURL1
        
        // self.upload(uploadRequest1)
        
        
        //selfImage.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        tableView.reloadData()
    }
}

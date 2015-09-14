//
//  ViewController.swift
//  EVChat
//
//  Created by EV Technologies Inc. on 2015-09-10.
//  Copyright © 2015 EV Technologies Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var ChatContainer: UIView!
    @IBOutlet weak var InsideContainer: UIView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    @IBOutlet var SwipeRight: UISwipeGestureRecognizer!
    @IBOutlet var SwipeLeft: UISwipeGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark: Segmented Controller
    @IBAction func SegmentSwitch(sender: UISegmentedControl) {
        switch SegmentControl.selectedSegmentIndex
        {
        case 0:
            self.ChatContainer.hidden = true
            self.InsideContainer.hidden = false
        case 1:
            self.ChatContainer.hidden = false
            self.InsideContainer.hidden = true
        default:
            break; 
        }
    }
    
    // Mark: Swipe gesture
    @IBAction func swipeRight(sender: AnyObject) {
        self.ChatContainer.hidden = true
        self.InsideContainer.hidden = false
        SegmentControl.selectedSegmentIndex = 0
    }
    
    @IBAction func swipeLeft(sender: AnyObject) {
        self.ChatContainer.hidden = false
        self.InsideContainer.hidden = true
        SegmentControl.selectedSegmentIndex = 1
    }
    
    

}


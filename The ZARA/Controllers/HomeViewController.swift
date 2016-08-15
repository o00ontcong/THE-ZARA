//
//  HomeViewController.swift
//  The ZARA
//
//  Created by MAC on 15/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import CarbonKit

class HomeViewController: UIViewController {

    @IBAction func abtnBack(sender: AnyObject) {
        let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("startVC")
        self.presentViewController(destinationVC, animated: true, completion: nil)
    }
    
    @IBAction func abtnNewIn(sender: AnyObject) {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerViewController
        destinationVC.group = "NEW IN"
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    @IBAction func abtnWoman(sender: AnyObject) {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerViewController
        destinationVC.group = "WOMAN"
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func abtnMan(sender: AnyObject) {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerViewController
        destinationVC.group = "MAN"
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @IBAction func abtnKids(sender: AnyObject) {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerViewController
        destinationVC.group = "KIDS"
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Home")
//        displayWalkthroughs()
    }


    
    func displayWalkthroughs() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let displayedWalkthrough = userDefaults.boolForKey("DisplayedWalkthrough")
        
        if !displayedWalkthrough {
            if let startViewController = storyboard?.instantiateViewControllerWithIdentifier("startVC") as? StartViewController{
                self.presentViewController(startViewController, animated: false , completion: nil)
            }
            
            
        }
    }

 
 

}






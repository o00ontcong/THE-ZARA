//
//  ContainerViewController.swift
//  The ZARA
//
//  Created by MAC on 27/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import CarbonKit
import Firebase

class ContainerViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet weak var labelTitle: UINavigationItem!
    
    @IBAction func abtnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var group : String = String()
    var vcTitles = ["Product type 1", "Product type 2", "Product type 3","Product type 4"]
    
    var myCarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    //Firebase
    
    let database = FIRDatabase.database().reference()
    var loadingState: UIView = UIView()
    var cache : NSCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTitle.title = group
        loadData(group)
  
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    //MARK: - Firebase database
    
    func loadData(keyId: String) {
        loadingState = LoadingState.shareInstance.createLoadingState()
        self.view.addSubview(loadingState)
        self.database.child(keyId).observeEventType(.Value, withBlock: { (snap) in
            self.parseData(snap)
        })
    }
    func parseData(snap: FIRDataSnapshot) {
        vcTitles.removeAll()
        for item in snap.children.allObjects.reverse() {
            if let typeInfo = item as? FIRDataSnapshot {
                vcTitles.append(typeInfo.key)
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                
                UIView.animateWithDuration(0.25, animations: {
                    self.loadingState.layer.opacity = 0
                    }, completion: { (_) in
                        self.loadingState.removeFromSuperview()

                        self.createCarbon()
                })
            }
        })
    }
    
    // MARK: - Carbon
    func createCarbon() {
        self.myCarbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: self.vcTitles, delegate: self)
        self.myCarbonTabSwipeNavigation.insertIntoRootViewController(self)
        let color: UIColor = UIColor.blackColor()
        myCarbonTabSwipeNavigation.setIndicatorColor(color)
        myCarbonTabSwipeNavigation.setNormalColor(color.colorWithAlphaComponent(0.6), font: UIFont.boldSystemFontOfSize(14))
        myCarbonTabSwipeNavigation.setSelectedColor(color, font: UIFont.boldSystemFontOfSize(14))
    }
    
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("CustomVC") as! CustomViewController
        for i in 0...vcTitles.count - 1 {
            if i == Int(index) {
            destinationVC.group = self.group
            destinationVC.type = self.vcTitles[i]
            }
        }
        return destinationVC
        
    }
    func carbonTabSwipeNavigation(carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAtIndex index: UInt) {
        self.title = group
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     print("segue : \(segue.identifier)")
     }
     */
    
    
}


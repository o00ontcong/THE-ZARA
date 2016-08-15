//
//  ShippingInfoViewController.swift
//  The ZARA
//
//  Created by MAC on 08/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

class ShippingInfoViewController: UIViewController {

    @IBAction func abtnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var imageAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(animated: Bool) {
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.bounds.width / 2.0
        self.imageAvatar.layer.borderWidth = 3.0
        self.imageAvatar.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageAvatar.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

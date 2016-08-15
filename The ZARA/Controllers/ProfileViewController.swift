//
//  ProfileViewController.swift
//  The ZARA
//
//  Created by MAC on 10/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBAction func abtnLogout(sender:   AnyObject) {
        
        try! FIRAuth.auth()?.signOut()
        getCurrentlySignedinUser()
    }
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentlySignedinUser()

    }
    
    func getCurrentlySignedinUser() {
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user {
                if let photoUrl = user.photoURL {
                    if let data = NSData(contentsOfURL: photoUrl) {
                        let image = UIImage(data: data)
                        let newImage = image?.createOval(self.imageUser.bounds.size)
                        self.imageUser.image = newImage
                    }
                }
                self.labelName.text = user.displayName
                self.labelMail.text = user.email
            } else {
                let img = UIImage(named: "nobody")?.createOval(self.imageUser.bounds.size)
                self.imageUser.image = img
                self.labelName.text = "No name"
                self.labelMail.text = "nomail@gmail.com"
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//        let img = self.imageUser.image?.createRadius(imageUser.bounds.size, radius: imageUser.bounds.width / 2, byRoundingCorners: [.AllCorners])
        let img = self.imageUser.image?.createOval(imageUser.bounds.size)
        self.imageUser.image = img
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

//
//  SignInViewController.swift
//  The ZARA
//
//  Created by MAC on 12/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBAction func abtnResetPass(sender: AnyObject) {
        let alert = UIAlertController(title: "Password Reset", message: "To reset your password, enter the email address you use to sign in", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter Email"
        }
        let Reset = UIAlertAction(title: "Reset", style: .Default, handler: { (snap) in
            if let alertTextField = alert.textFields?.first  {
                if let email = alertTextField.text {
                    FIRAuth.auth()?.sendPasswordResetWithEmail(email, completion: { (error) in
                        if let error = error {
                            let alert = UIAlertController(title: "Notification", message: error.userInfo["NSLocalizedDescription"] as? String, preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(ok)
                            self.presentViewController(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Notification", message: "Reset successfully", preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(ok)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
            
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(Reset)
        alert.addAction(Cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func abtnSignIn(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(inputEmail.text!, password: inputPassword.text!, completion: { (user, error) in
            if user != nil {
                let alert = UIAlertController(title: "Notification", message: "Login successfully", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: {
                    (snap) in
                    let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("rootVC")
                    self.presentViewController(destinationVC, animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Notification", message: error?.userInfo["NSLocalizedDescription"] as? String, preferredStyle: .Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    
    @IBAction func abtnFB(sender: AnyObject) {
    }
    
    @IBAction func abtnGG(sender: AnyObject) {
    }
    
    @IBAction func abtnTW(sender: AnyObject) {
    }
    
    @IBAction func abtnBack(sender: AnyObject) {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("startVC") as! StartViewController
        self.presentViewController(destinationVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

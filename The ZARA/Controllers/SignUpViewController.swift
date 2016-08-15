//
//  SignUpViewController.swift
//  The ZARA
//
//  Created by MAC on 12/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageUser: UIButton!
    @IBAction func abtnImageUser(sender: AnyObject) {
        showImagePicker(.PhotoLibrary)
    }
    
    @IBAction func abtnBack(sender: AnyObject) {
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("signInVC") as! SignInViewController
        self.presentViewController(destinationVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassWord: UITextField!
    
    @IBAction func abtnSignUp(sender: AnyObject) {
        if let email = inputEmail.text {
            if let password = inputPassWord.text {
                FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                    if let user = user {
                        let changeRequest = user.profileChangeRequest()
                        var name = "No Name"
                        if let inputname = self.inputName.text {
                            name = inputname
                        }
                        changeRequest.displayName = name
                        var photoUrl = ""
                        let storge = FIRStorage.storage()
                        let rootFolder = storge.referenceForURL("gs://the-zara.appspot.com")
                        let imageFolder = rootFolder.child("PhotoUser")
                        let imageFile = imageFolder.child("\(name).jpg")
                        if let myImage = self.imageUser.currentImage  {
                            
                            UIGraphicsBeginImageContext(CGSizeMake(100, 100))
                            myImage.drawInRect(CGRectMake(0, 0, 100, 100))
                            let newImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            
                            if let imageData = UIImagePNGRepresentation(newImage) {
                                imageFile.putData(imageData, metadata: nil, completion: { (data, error) in
                                    if let data = data {
                                        photoUrl = (data.downloadURL()?.absoluteString)!
                                        changeRequest.photoURL = NSURL(string: photoUrl)
                                        changeRequest.commitChangesWithCompletion({
                                            (error) in
                                            if let error = error {
                                                print(error.userInfo["NSLocalizedDescription"])
                                            }
                                        })
                                        
                                        //
                                        
                                        let alert = UIAlertController(title: "Notification", message: "Seccessfully signed up!", preferredStyle: .Alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (snap) in
                                            let destinationVC = self.storyboard!.instantiateViewControllerWithIdentifier("signInVC") as! SignInViewController
                                            self.presentViewController(destinationVC, animated: true, completion: nil)
                                        })
                                        alert.addAction(ok)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                })
                            }
                           
                        }


                    } else {
                        let alert = UIAlertController(title: "Notification", message: error?.userInfo["NSLocalizedDescription"] as? String, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated: true, completion: nil)

                    }
                    
                })
            }
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showImagePicker(sourceType : UIImagePickerControllerSourceType) {
        let imgPickerVC = UIImagePickerController()
        imgPickerVC.delegate = self
        imgPickerVC.sourceType = sourceType
        presentViewController(imgPickerVC, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageUser.setImage(image, forState: .Normal)
        imageUser.layer.cornerRadius = imageUser.bounds.width / 2.0
        imageUser.layer.masksToBounds = true
        dismissViewControllerAnimated(true, completion: nil)
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

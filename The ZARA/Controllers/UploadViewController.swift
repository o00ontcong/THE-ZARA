//
//  UploadViewController.swift
//  The ZARA
//
//  Created by MAC on 01/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCount: UITextField!
    
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelNotif: UILabel!
    
    
    
    let storge = FIRStorage.storage()
    let database = FIRDatabase.database().reference()
    
    
    let group = "NEW IN"
    let type = "WOMAN"
    var nameProduct = "xxx"
    var priceProduct = 0
    var countProduct = 0
    var arrayUrls = [String:String]()
    @IBAction func abtnUpload(sender: AnyObject) {
        let rootFolder = storge.referenceForURL("gs://the-zara.appspot.com")
        let imageFolder = rootFolder.child(group).child(type)
        self.countProduct = Int(txtCount.text!)!
        self.nameProduct = txtName.text!
        arrayUrls.removeAll()
        for i in 1...countProduct {
            
            let imageFile = imageFolder.child("\(nameProduct)\(i).jpg")
            let bundle = NSBundle.mainBundle().URLForResource(nameProduct + String(i), withExtension: "jpg")
            let imageData = NSData(contentsOfURL: bundle!)
            
            imageFile.putData(imageData!, metadata: nil, completion: {
                (data , error) in
                if error != nil {
                    print("error: \(error)")
                } else {
                    self.arrayUrls["url\(i)"] = data?.downloadURL()?.absoluteString
                    self.labelCount.text = String(self.arrayUrls.count)
                    print("Success: \(String(self.arrayUrls.count))")
                }
            })
            
        }
        
        
        
    }
    
    @IBAction func abtnDatabase(sender: AnyObject) {
        
        self.nameProduct = txtName.text!
        self.priceProduct = Int(txtPrice.text!)!
        
        
        let productInfo: [String:AnyObject] = [
            "name" : nameProduct,
            "price" : priceProduct,
            "urls" : arrayUrls
        ]
        
        self.database.child(group).child(type).childByAutoId().setValue(productInfo, withCompletionBlock: { (error , data) in
            if error != nil {
//                labelNotif.text = error
                print(error)
            } else {
                self.labelNotif.text = "Success"
                print("Success")
                self.arrayUrls.removeAll()
            }
            
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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

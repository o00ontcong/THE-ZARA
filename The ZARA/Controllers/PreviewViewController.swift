//
//  PreviewViewController.swift
//  The ZARA
//
//  Created by MAC on 02/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewFrame: UIView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    var myProduct: Product!
    let database = FIRDatabase.database().reference()
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBAction func abtnAdd(sender: AnyObject) {
        let alert = UIAlertController(title: "Notification", message: "Are you sure ?", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "YES", style: .Default) { (snap) in
            var arrayUrls = [String:String]()

            for i in 0...self.myProduct.urls.count - 1{
                arrayUrls["url\(i + 1)"] = self.myProduct.urls[i]
            }
            let productInfo: [String:AnyObject] = [
                "name" : self.myProduct.name,
                "price" : self.myProduct.price,
                "urls" : arrayUrls
            ]
            
            self.database.child("SHOPCART").child(self.myProduct.id).setValue(productInfo, withCompletionBlock: { (error , data) in
                if error != nil {
                    print(error)
                } else {
                    print("Success")
                }
                
            })
        }

        let cancel = UIAlertAction(title: "NO", style: .Cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageController.numberOfPages = myProduct.urls.count
        pageController.defersCurrentPageDisplay = true
        pageController.transform = CGAffineTransformMakeRotation( CGFloat(M_PI/2))
        scrollView.delegate = self
        
        labelName.text = myProduct.name
        labelPrice.text = String(myProduct.price).uppercaseString + " USD"
    }
    
    override func viewDidAppear(animated: Bool) {
        let width = CGRectGetWidth(viewFrame.bounds)
        let height = CGRectGetHeight(viewFrame.bounds)
        scrollView.contentSize.width = width * CGFloat(myProduct.urls.count)
        for i in 0...myProduct.urls.count - 1{
            
            let queue = dispatch_queue_create("priview product", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(queue, {
                let myRect = CGRectMake(width * CGFloat(i), 0, width, height)
                let url = NSURL(string: self.myProduct.urls[i])
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                let imageView = UIImageView(frame: myRect)
                imageView.image = image
                dispatch_async(dispatch_get_main_queue(), {
                    self.scrollView.addSubview(imageView)
                })
            })
        }
    }
    
    
    

    
}
extension PreviewViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = CGRectGetWidth(scrollView.bounds)
        let pageFraction = scrollView.contentOffset.x / pageWidth
        pageController.currentPage = Int(pageFraction)
    }
}

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
        let ok = UIAlertAction(title: "YES", style: .Default, handler: nil)
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
            let myRect = CGRectMake(width * CGFloat(i), 0, width, height)
            let url = NSURL(string: myProduct.urls[i])
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            let imageView = UIImageView(frame: myRect)
            imageView.image = image
            self.scrollView.addSubview(imageView)
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

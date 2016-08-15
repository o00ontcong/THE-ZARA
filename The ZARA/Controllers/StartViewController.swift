//
//  StartViewController.swift
//  The ZARA
//
//  Created by MAC on 17/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    

    @IBAction func abtnShop(sender: AnyObject) {
    }
    @IBAction func abtnSignIn(sender: AnyObject) {
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pageView: UIScrollView!

    var pageImages = ["Group1","Group2","Group3","Group4"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(pageView, atIndex: 1)
        
        print("StartVC")
        self.pageView.contentSize.width = view.bounds.size.width * CGFloat(pageImages.count)
        self.pageView.delegate = self
        self.view.insertSubview(pageView, atIndex: 0)
        self.pageControl.numberOfPages = pageImages.count
        self.pageControl.defersCurrentPageDisplay = true
        
        for i in 0...pageImages.count - 1{
            let myRect = CGRectMake(view.bounds.size.width * CGFloat(i), 0, view.bounds.size.width, view.bounds.size.height)
            let image = UIImage(named: pageImages[i])
            let imageView = UIImageView(frame: myRect)
            imageView.image = image
            self.pageView.addSubview(imageView)
        }
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
extension StartViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = CGRectGetWidth(scrollView.bounds)
        let pageFraction = scrollView.contentOffset.x / pageWidth
        pageControl.currentPage = Int(pageFraction)
    }
}

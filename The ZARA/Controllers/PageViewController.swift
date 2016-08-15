//
//  PageViewController.swift
//  The ZARA
//
//  Created by MAC on 15/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var pageImages = ["Group1","Group2","Group3","Group4"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let startWalkthroughVC = self.viewControllerAtIndex(0) {
            setViewControllers([startWalkthroughVC], direction: .Forward, animated: true, completion: nil)
        }
        
    }


    
    //MARK: Navigate
    
    func nextPageViewController(index: Int) {
        if let nextWalkthroughVC = self.viewControllerAtIndex(index + 1){
            setViewControllers([nextWalkthroughVC], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> WalkthroughViewController? {
        if index == NSNotFound || index < 0 || index >= self.pageImages.count{
            return nil
        }
        if let walkthroughViewController =  storyboard?.instantiateViewControllerWithIdentifier("WalkthroughViewController") as?WalkthroughViewController {
            walkthroughViewController.imageName = pageImages[index]
            walkthroughViewController.index = index
            return walkthroughViewController
        }
        
        return nil
        
        
        
    }

}
extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return self.viewControllerAtIndex(index)
    }
}


//
//  StartViewController.swift
//  The ZARA
//
//  Created by MAC on 15/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    
    // MARK: - Data model for each walkthrough screen
    var index = 0               // the current page index
    var imageName = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: imageName)
        pageController.currentPage = index
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
}

//
//  YourCartViewController.swift
//  The ZARA
//
//  Created by MAC on 08/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase
class YourCartViewController: UIViewController {

    @IBOutlet weak var tableViewYourCart: UITableView!
    
    @IBOutlet weak var labelItems: UILabel!
    
    @IBOutlet weak var labelTotalPrice: UILabel!
    
    @IBAction func abtnNext(sender: AnyObject) {
    }
    
    let database = FIRDatabase.database().reference()
    var myProduct = [Product]()
    
    //firebase load image
    let productCache:NSCache = NSCache()
    var downloadingTasks = Dictionary<NSIndexPath,NSOperation>()
    lazy var downloadPhotoQueue:NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "Download Photo"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewYourCart.dataSource = self
        tableViewYourCart.delegate = self
        let bundle = NSBundle.mainBundle()
        tableViewYourCart.backgroundColor = view.backgroundColor
        let nib = UINib(nibName: "YourCartTableViewCell", bundle: bundle)
        tableViewYourCart.registerNib(nib, forCellReuseIdentifier: "cellYourCart")
        loadData()

    }
    func loadData() {

        self.database.child("SHOPCART").observeEventType(.Value, withBlock: { (snap) in
            self.parseData(snap)
//            print(snap)
        })
    }
    func parseData(snap: FIRDataSnapshot) {
        myProduct.removeAll()
        for item in snap.children.allObjects.reverse() {
            if let productSnap = item as? FIRDataSnapshot {
                let key = productSnap.key
                let productInfo = productSnap.value as! [String:AnyObject]
                
                if let product: Product = Product(id: key, productInfo: productInfo) {
                    self.myProduct.append(product)
                }
            }
        }
        
        var total = 0
        for i in 0...myProduct.count - 1 {
            total += myProduct[i].price
        }
        labelItems.text = String(myProduct.count) + " items"
        labelTotalPrice.text = String(total) + ".00 $"
        tableViewYourCart.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {

        
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
extension YourCartViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return myProduct.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellYourCart", forIndexPath: indexPath) as! YourCartTableViewCell

        let productCurrent = myProduct[indexPath.section]

        cell.labelName.text = productCurrent.name
        cell.labelPrice.text = String(productCurrent.price)
        
        let keyCache = productCurrent.id
        
        if let downloadedIMG = productCache.objectForKey(keyCache) as? UIImage{
            cell.imageAvatar.image = downloadedIMG
        } else {
            cell.imageAvatar.image = UIImage(named: "NoPicture")
            let queue = dispatch_queue_create("the ZARA", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(queue, { 
                if let url = NSURL(string: String(productCurrent.urls[0])) {
                    if let data = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue(), {
                            if let image = UIImage(data: data){
                            self.productCache.setObject(image, forKey: keyCache)
                            cell.imageAvatar.image = image
                            }
                        })
                    }

                }
                
            })
        }
        return cell
    }
    
    
}
extension YourCartViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}



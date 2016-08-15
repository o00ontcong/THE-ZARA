//
//  PaymentViewController.swift
//  The ZARA
//
//  Created by MAC on 08/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBAction func abtnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var tableViewPayment: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPayment.dataSource = self
        tableViewPayment.delegate = self
        let bundle = NSBundle.mainBundle()
        tableViewPayment.backgroundColor = view.backgroundColor
        let nib = UINib(nibName: "YourCartTableViewCell", bundle: bundle)
        tableViewPayment.registerNib(nib, forCellReuseIdentifier: "cellYourCart")
    }



}

extension PaymentViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellYourCart", forIndexPath: indexPath) as! YourCartTableViewCell
        return cell
    }
}
extension PaymentViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

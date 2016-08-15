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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewYourCart.dataSource = self
        tableViewYourCart.delegate = self
        let bundle = NSBundle.mainBundle()
        tableViewYourCart.backgroundColor = view.backgroundColor
        let nib = UINib(nibName: "YourCartTableViewCell", bundle: bundle)
        tableViewYourCart.registerNib(nib, forCellReuseIdentifier: "cellYourCart")

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
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellYourCart", forIndexPath: indexPath) as! YourCartTableViewCell

        cell.imageAvatar.image = UIImage(named: "Group1")
        cell.labelName.text = "PRINTED CROP"
        cell.labelPrice.text = "123 USD"
        return cell
    }
    
    
}
extension YourCartViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

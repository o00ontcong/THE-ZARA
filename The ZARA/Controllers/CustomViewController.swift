//
//  CustomViewController.swift
//  The ZARA
//
//  Created by MAC on 27/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import Firebase

class CustomViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellPadding : CGFloat = 45
    let numberOfItemPerRow : CGFloat = 2
    let heightAdjustment: CGFloat = 30
    
    //firebase
    var group = String()
    var type = String()
    let database = FIRDatabase.database().reference()
    
    //Firebase loaddata lime
    var myProduct = [Product]()
    var nextKeyId:String?
    
    var ignoreFirstTimeObserver = true
    var isLoading       = false
    var isFirstLoad     = true
    var isHastNext      = true
    let productPerPage:UInt      = 6
    
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        if isFirstLoad {
            isFirstLoad = false
            loadData(nil)
        }
    }
    
    func loadData(nextKeyId: String?) {
        if isLoading || !isHastNext {
            return
        }
        
        isLoading = true
        
                if let nextKeyId = self.nextKeyId {
                    database.child(group).child(type).queryOrderedByKey().queryEndingAtValue(nextKeyId).queryLimitedToLast(productPerPage + 1).observeSingleEventOfType(.Value, withBlock: { (snap) in
                        self.parseData(snap)
                    })
                } else {
                    self.myProduct.removeAll()
                    database.child(group).child(type).queryOrderedByKey().queryLimitedToLast(productPerPage).observeSingleEventOfType(.Value, withBlock: { (snap) in
                        self.parseData(snap)
                    })
                }
        
    }
    
    func parseData(snap: FIRDataSnapshot) {
        self.isHastNext = snap.children.allObjects.count > 1
        if snap.children.allObjects.count == 0 { return }
        if snap.children.allObjects.count == 1 && nextKeyId != nil { return }
        for item in snap.children.allObjects.reverse() {
            if let productSnap = item as? FIRDataSnapshot {
                
                if let nextKeyId = self.nextKeyId where nextKeyId == productSnap.key { continue}
                let key = productSnap.key
                let productInfo = productSnap.value as! [String:AnyObject]
                
                if let product: Product = Product(id: key, productInfo: productInfo) {
                    self.myProduct.append(product)
                }
                
                self.nextKeyId = key
            }
        }
        
        self.collectionView.reloadData()
        isLoading = false
        
        
    }
    //MARK: - CollectionView DataScource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return myKey.count
        return myProduct.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        let productCurrent = myProduct[indexPath.item]
        
        cell.labelName.text = productCurrent.name.uppercaseString
        let price = String(productCurrent.price).uppercaseString + " USD"
        cell.labelPrice.text = price
        
        
        let keyCache = productCurrent.id
        
        if let downloadedIMG = productCache.objectForKey(keyCache) as? UIImage{
            cell.imageView.image = downloadedIMG
        } else {
            cell.layoutIfNeeded()
            cell.imageView.image = UIImage(named: "NoPicture")
            let url = productCurrent.urls[0]
            if !collectionView.decelerating {
                let downloadPhoto = DownloadImageOperation(indexPath: indexPath, photoURL: url, delegate: self)
                startDownloadImage(downloadPhoto, indexPath: indexPath)
            }
            
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let destinationVC = storyboard!.instantiateViewControllerWithIdentifier("PreviewVC") as! PreviewViewController
        destinationVC.myProduct = myProduct[indexPath.item]
        self.navigationController?.showViewController(destinationVC, sender: true)
    }
    
    //MARK: - CollectionViewLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (CGRectGetWidth(collectionView.frame) - cellPadding)/numberOfItemPerRow
        
        let mySize = CGSize(width: width, height: (width * 5)/3)
        return mySize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 15
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    //ScrollView
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.bounds.size.height
        
        if offsetY >= scrollView.contentSize.height{
            loadData(nextKeyId)
        }
        reloadVisibleCells()
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.decelerating {
            downloadingTasks.removeAll()
        }
    }
    func reloadVisibleCells() {
        UIView.setAnimationsEnabled(false)
        self.collectionView.performBatchUpdates({
            let visibleCellIndexPaths = self.collectionView.indexPathsForVisibleItems()
            self.collectionView.reloadItemsAtIndexPaths(visibleCellIndexPaths)
        }) { (finished) in
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func startDownloadImage(operation: DownloadImageOperation, indexPath: NSIndexPath)  {
        if let _ = downloadingTasks[indexPath]{
            return
        }
        downloadingTasks[indexPath] = operation
        downloadPhotoQueue.addOperation(operation)
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

extension CustomViewController : DownloadImageOperationDelegate {
    func downloadPhotoDidFail(operation: DownloadImageOperation) {
        
    }
    func downloadPhotoDidFinish(operation: DownloadImageOperation, image: UIImage) {
        let productPhoto = myProduct[operation.indexPath.item]
        let keyCache = productPhoto.id
        
        let cell = self.collectionView(self.collectionView, cellForItemAtIndexPath: operation.indexPath) as! CustomCollectionViewCell
        
        let resultImg = image.scaleImage(cell.imageView.bounds.size)
        self.productCache.setObject(resultImg, forKey: keyCache)
        self.collectionView.reloadItemsAtIndexPaths([operation.indexPath])
        downloadingTasks.removeValueForKey(operation.indexPath)
    }
}

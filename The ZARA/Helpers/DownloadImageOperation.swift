//
//  DownloadPhotoOperation.swift
//  The ZARA
//
//  Created by MAC on 14/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

protocol DownloadImageOperationDelegate: class {
    func downloadPhotoDidFinish(operation:DownloadImageOperation, image:UIImage)
    func downloadPhotoDidFail(operation:DownloadImageOperation)
}

class DownloadImageOperation: NSOperation {

    let indexPath:NSIndexPath
    let photoURL:String
    weak var delegate:DownloadImageOperationDelegate?

    init(indexPath:NSIndexPath, photoURL:String, delegate:DownloadImageOperationDelegate?) {
        self.indexPath = indexPath
        self.photoURL = photoURL
        self.delegate = delegate
    }

    override func main() {
        if cancelled { return }
        let url = NSURL(string: photoURL)
        let imgData = NSData(contentsOfURL: url!)
        if let downloadedImage = UIImage(data: imgData!) {

            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.downloadPhotoDidFinish(self, image: downloadedImage)
            }
            
        } else {
            handleFail()
        }
        
    }
    private func handleFail() {
        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.downloadPhotoDidFail(self)
        }

    }
    
    
}

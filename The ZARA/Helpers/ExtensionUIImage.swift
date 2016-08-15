//
//  ExtensionUIImage.swift
//  The ZARA
//
//  Created by MAC on 13/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func createRadius(newSize: CGSize,radius: CGFloat, byRoundingCorners: UIRectCorner?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let imgRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        if let roundingCorners = byRoundingCorners{
            UIBezierPath(roundedRect: imgRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius)).addClip()
            
        } else {
            UIBezierPath(roundedRect: imgRect, cornerRadius: radius).addClip()
        }
        self.drawInRect(imgRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func createOval(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let imgRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIBezierPath(ovalInRect: imgRect).addClip()

        self.drawInRect(imgRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func scaleImage(newSize:CGSize) -> UIImage {
        
        // Core Graphic
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let result:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
}
//
//  Product.swift
//  The ZARA
//
//  Created by MAC on 02/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import Foundation

class Product {
    var id : String 
    var name: String
    var price: Int
    var urls : [String] = [String]()
    
    init?(id:String,productInfo:[String:AnyObject]){
        self.id = id
        guard  let name = productInfo["name"] as? String,
               let price = productInfo["price"] as? Int
     else { return nil }
        if let urls = productInfo["urls"] as? [String:String]{
            for i in 1...urls.count {
                if let temp = urls["url\(i)"] {
                    self.urls.append(temp)
                }
            }
        }
        self.name = name
        self.price = price
    }
    

    
}
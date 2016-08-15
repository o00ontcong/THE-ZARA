//
//  LoadingState.swift
//  Euro 2016
//
//  Created by MAC on 09/07/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import Foundation
import UIKit

class LoadingState {
    static let shareInstance = LoadingState()
    
    
    func createLoadingState() -> UIView {
        let width : CGFloat = 280
        let height : CGFloat = 140
        let screenSize = UIScreen.mainScreen().bounds.size
        let viewState = UIView(frame: CGRect(x: screenSize.width/2 - (width/2), y: screenSize.height/2 - (height/2), width: width, height: height))
        viewState.layer.zPosition = 1
        viewState.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        let imgView = UIImageView(frame: CGRect(x: -100, y: 10, width: 100, height: 120))
        let character = UIImage(named: "shoppingcart")
        imgView.image = character
        imgView.contentMode = .ScaleAspectFit
        viewState.layer.cornerRadius = 10
        viewState.addSubview(imgView)
        viewState.clipsToBounds = true
        UIView.animateKeyframesWithDuration(2, delay: 0, options: [.Repeat,.CalculationModeLinear], animations: {
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25, animations: {
                imgView.center.x = CGRectGetMidX(viewState.bounds)
            })
            UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 1, animations: {
                imgView.center.x = CGRectGetMaxX(viewState.bounds) + width*2
            })
            }, completion: nil)
        return viewState
    }
}
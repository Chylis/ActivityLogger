//
//  UIViewAnimationAdditions.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit

extension UIView {
    
    var defaultAnimationDuration: Double { get { return 0.20 } }
    
    func addTransitionAnimation(completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let anim = CATransition()
        anim.duration = defaultAnimationDuration
        anim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        layer.addAnimation(anim, forKey: nil)
        CATransaction.commit()
    }
}
//
//  UIViewControllerUtilityAdditions.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 01/01/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func isInLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func dismissAnimated() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

//
//  UIStoryboardActivityLoggerAdditions.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 31/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class func overviewStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Overview", bundle: nil)
    }
    
    class func logActivityStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "LogActivityStoryboard", bundle: nil)
    }
    
}

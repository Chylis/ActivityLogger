//
//  ActivityOverviewBarView.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 29/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit

class ActivityOverviewBarView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRectZero)
        commonInit()
    }
    
    func commonInit() {
        addBorder()
    }
    
    func addBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.blackColor().CGColor
    }
}

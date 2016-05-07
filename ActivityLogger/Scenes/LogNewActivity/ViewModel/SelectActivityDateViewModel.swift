//
//  SelectActivityDateViewModel.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 04/01/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import Foundation


struct SelectActivityDateViewModel {

    //MARK: Public
    
    /**
    Returns the maximum allowed date
    */
    func maximumDate() -> NSDate {
        return NSDate()
    }
    
    func title() -> String {
        //TODO: Localize
        return "Select date"
    }
    
    func proceedTitle() -> String {
        return "Proceed"
    }

}
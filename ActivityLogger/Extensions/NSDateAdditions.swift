//
//  NSDateAdditions.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import Foundation

extension NSDate {
    
    /**
     Returns a formatted string from the received date, in the 'EEEE d' format
     E.g. "Monday 25"
     */
    func formattedDayOfMonth() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE d"
        return dateFormatter.stringFromDate(self)
    }
    
    /**
     Returns a formatted string from the received date
     
     - returns: A formatted string in the yyyy-MM-dd format
     */
    func formattedMonth() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.stringFromDate(self)
    }
    
    func formattedYear() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.stringFromDate(self)
    }
    
    /**
     Returns the absolute week number of the year
     */
    func weekOfYear() -> Int {
        return NSCalendar
            .currentCalendar()
            .ordinalityOfUnit(.WeekOfYear, inUnit: .Year, forDate: self)
    }
}
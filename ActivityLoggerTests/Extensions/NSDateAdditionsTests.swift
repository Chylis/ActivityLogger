//
//  NSDateAdditionsTests.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import XCTest
import Timepiece
@testable import ActivityLogger

class NSDateAdditionsTests: XCTestCase {
    
    private let dateFormat = "yyyy-MM-dd"
    
    func testWeekOfYear() {
        //Weeks begin on Sundays
        var date: NSDate = "2015-12-26".dateFromFormat(dateFormat)!
        var expectedWeekNo = 52
        XCTAssertEqual(date.weekOfYear(), expectedWeekNo)
        
        date = "2015-12-27".dateFromFormat(dateFormat)!
        expectedWeekNo = 53
        XCTAssertEqual(date.weekOfYear(), expectedWeekNo)
        
        date = "2015-12-31".dateFromFormat(dateFormat)!
        XCTAssertEqual(date.weekOfYear(), expectedWeekNo)
        
        date = "2016-01-01".dateFromFormat(dateFormat)!
        expectedWeekNo = 1
        XCTAssertEqual(date.weekOfYear(), expectedWeekNo)
    }
}

//
//  ActivityModelTests.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import XCTest
@testable import ActivityLogger

class ActivityModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSquash() {
        let squash = ActivityModel()
        squash.comment = "Average"

        var activityType: ActivityType = .Squash
        var comment = "Average"
        
        XCTAssertEqual(activityType, squash.type)
        XCTAssertEqual(comment, squash.comment)

        activityType = .Run
        comment = "Bad run!"
        
        XCTAssertFalse(activityType == squash.type)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}

    //
//  ActivityOverviewViewModelTests.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 25/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import XCTest
import RealmSwift
import Timepiece

@testable import ActivityLogger

class ActivityOverviewViewModelTests: XCTestCase {
    

    
    override class func setUp() {
        super.setUp()
        configureRealm()
    }
    
    
    private class func configureRealm() {
        Realm.Configuration.defaultConfiguration.path = "/tmp/ActivityOverviewViewModelTestDatabase.realm"
    }
    
    
    /**
     Populates the test database with two activities each week over the span of a year.
     Asserts that the number of performed activities returned for the weekly view state corresponds to the number of registered activities
     */
    func testWeeklyTableViewDataSource() {
        //Clear database
        let db = DatabaseService()
        db?.deleteAll()
        
        //Populate database with 2 activities per week over the span of a year
        var date = NSDate.date(year: 2016, month: 1, day: 1).beginningOfYear
        let initialYear = date.year
        
        while date.year == initialYear {
            let activity1 = ActivityModel()
            activity1.date = date.beginningOfWeek
            db?.writeObject(activity1)
            
            let activity2 = ActivityModel()
            activity2.date = date.endOfWeek
            db?.writeObject(activity2)
            
            
            date = date + 2.week
        }
        
        
        //Create testable view model with weekly view state
        let testable = ActivityOverviewViewModel()
        testable.viewState.value = .Week

        //First week should have 2 activities
        testable.selectedDate.value = NSDate.date(year: 2016, month:1, day:1)
        var expectedNumberOfActiveDaysInWeek = 2
        let numberOfActivitiesPerActiveDay = 1

        var dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActiveDaysInWeek, dataSource.count)
        
        for (_, activities) in dataSource {
            XCTAssert(activities.count == numberOfActivitiesPerActiveDay)
        }
        
        
        //Second week should have 0 activities
        testable.selectedDate.value = testable.selectedDate.value + 1.week
        expectedNumberOfActiveDaysInWeek = 0
        dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActiveDaysInWeek, dataSource.count)
        
        
        //Third week should have 2 activities
        testable.selectedDate.value = testable.selectedDate.value + 1.week
        expectedNumberOfActiveDaysInWeek = 2
        dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActiveDaysInWeek, dataSource.count)
        
        for (_, activities) in dataSource {
            XCTAssert(activities.count == numberOfActivitiesPerActiveDay)
        }
    }
    
    
    
    /**
     Populates the test database with two activities every second month over the span of a year.
     Asserts that the number of performed activities returned for the monthly view state corresponds to the number of registered activities
     */
    func testMonthlyTableViewDataSource() {
        //Clear database
        let db = DatabaseService()
        db?.deleteAll()
        
        //Populate database with 2 activities every second month over the span of a year
        var date = NSDate.date(year: 2016, month: 1, day: 1).beginningOfYear
        let initialYear = date.year
        
        while date.year == initialYear {
            let activity1 = ActivityModel()
            activity1.date = date.beginningOfMonth
            db?.writeObject(activity1)
            
            let activity2 = ActivityModel()
            activity2.date = date.endOfMonth
            db?.writeObject(activity2)
            
            
            date = date + 2.months
        }
        
        
        //Create testable view model with monthly view state
        let testable = ActivityOverviewViewModel()
        testable.viewState.value = .Month
        
        //First month should have 2 activities
        testable.selectedDate.value = NSDate.date(year: 2016, month:1, day:1)
        var expectedNumberOfActiveDaysInMonth = 2
        let numberOfActivitiesPerActiveDay = 1
        
        var dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActiveDaysInMonth, dataSource.count)
        
        for (_, activities) in dataSource {
            XCTAssert(activities.count == numberOfActivitiesPerActiveDay)
        }
        
        
        //Second month should have 0 activities
        testable.selectedDate.value = testable.selectedDate.value + 1.month
        expectedNumberOfActiveDaysInMonth = 0
        dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActiveDaysInMonth, dataSource.count)
        
        
        //Third month should have 2 activities
        testable.selectedDate.value = testable.selectedDate.value + 1.month
        expectedNumberOfActiveDaysInMonth = 2
        dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActiveDaysInMonth, dataSource.count)
        
        for (_, activities) in dataSource {
            XCTAssert(activities.count == numberOfActivitiesPerActiveDay)
        }
    }
    
    
    
    /**
     Populates the test database with two activities every second month over the span of a year.
     Asserts that the number of performed activities returned for the yearly view state corresponds to the number of registered activities
     */
    func testYearlyTableViewDataSource() {
        //Clear database
        let db = DatabaseService()
        db?.deleteAll()
        
        //Populate database with 1 activities every second month over the span of a year
        var date = NSDate.date(year: 2016, month: 1, day: 1).beginningOfYear
        let initialYear = date.year
        
        while date.year == initialYear {
            let activity1 = ActivityModel()
            activity1.date = date.beginningOfMonth
            db?.writeObject(activity1)
            date = date + 2.months
        }
        
        
        //Create testable view model with yearly view state
        let testable = ActivityOverviewViewModel()
        testable.viewState.value = .Year
        
        //Year should contain a total of 6 activities
        testable.selectedDate.value = NSDate.date(year: 2016, month:1, day:1)
        let expectedNumberOfActivitiesDuringYear = 6
        let numberOfActivitiesPerActiveDay = 1
        
        let dataSource = testable.tableViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfActivitiesDuringYear, dataSource.count)
        
        for (_, activities) in dataSource {
            XCTAssert(activities.count == numberOfActivitiesPerActiveDay)
        }
    }
    
    
    
    
    
    //MARK: Chart data source
    
    /**
    Populates the test database with two activities every second week over the span of a year.
    Asserts that the number of performed activities returned for the weekly view state corresponds to the number of registered activities
    */
    func testWeeklyLineChartDataSource() {
        //Clear database
        let db = DatabaseService()
        db?.deleteAll()
        
        //Populate database with 2 activities per week over the span of a year
        var date = NSDate.date(year: 2016, month: 1, day: 1).beginningOfYear
        let initialYear = date.year
        
        while date.year == initialYear {
            let activity1 = ActivityModel()
            activity1.date = date.beginningOfWeek
            db?.writeObject(activity1)
            
            let activity2 = ActivityModel()
            activity2.date = date.endOfWeek
            db?.writeObject(activity2)
            
            
            date = date + 2.week
        }
        
        
        //Create testable view model with weekly view state
        let testable = ActivityOverviewViewModel()
        testable.viewState.value = .Week
        
        //First week should have 2 activities
        testable.selectedDate.value = NSDate.date(year: 2016, month:1, day:1)
        let expectedNumberOfDaysPerWeek = 7
        var numberOfActivitiesPerActiveDay = 1
        
        var (healthy, _) = testable.lineChartViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfDaysPerWeek, healthy.count)
        
        for (weekDayIndex, activitiesForWeekDay) in healthy.enumerate() {
            if weekDayIndex == 0 || weekDayIndex == 6 {
                XCTAssert(activitiesForWeekDay.count == numberOfActivitiesPerActiveDay)
            } else {
                XCTAssert(activitiesForWeekDay.count == 0)
            }
        }
        
        
        //Second week should have 0 activities
        numberOfActivitiesPerActiveDay = 0
        testable.selectedDate.value = testable.selectedDate.value + 1.week
        (healthy, _) = testable.lineChartViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfDaysPerWeek, healthy.count)
        
        for (_, activitiesForWeekDay) in healthy.enumerate() {
            XCTAssert(activitiesForWeekDay.count == 0)
        }

        
        //Third week should have 2 activities
        numberOfActivitiesPerActiveDay = 1
        testable.selectedDate.value = testable.selectedDate.value + 1.week
        (healthy, _) = testable.lineChartViewDataSourceForCurrentViewState()
        XCTAssertEqual(expectedNumberOfDaysPerWeek, healthy.count)
        
        for (weekDayIndex, activitiesForWeekDay) in healthy.enumerate() {
            if weekDayIndex == 0 || weekDayIndex == 6 {
                XCTAssert(activitiesForWeekDay.count == numberOfActivitiesPerActiveDay)
            } else {
                XCTAssert(activitiesForWeekDay.count == 0)
            }
        }
    }
}

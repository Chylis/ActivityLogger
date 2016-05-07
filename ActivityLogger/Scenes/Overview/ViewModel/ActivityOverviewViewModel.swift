//
//  ActivityOverViewViewModel.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Timepiece

struct ActivityOverviewViewModel {
    
    //MARK: Stateful Properties
    
    let viewState = MutableProperty<ViewState>(.Week)
    let selectedDate = MutableProperty<NSDate>(NSDate())
    let db = DatabaseService()

    
    //MARK: Public
    
    
    /**
    Returns a table view data source based on the current view state.
    The data source consists of an array of tuples.
    Each tuple contains:
        - Key: String: representing the formatted section header of the date
        - Value: [ActivityModel]: Array of activities that belong to the key date
    */
    func tableViewDataSourceForCurrentViewState() -> [ (String, [ActivityModel]) ] {
        let dateRangeForCurrentViewState = 0..<viewState.value.numberOfUnitsInDate(selectedDate.value)

        if viewState.value == .Year {
            return performedActivitiesInMonthRange(dateRangeForCurrentViewState).map { (monthIndex, activities) in
                let monthDate = ViewState.Year.dateFromIndex(monthIndex, date: selectedDate.value)
                return ("\(monthDate.formattedMonth())", activities)
            }
        }
        
        return performedActivitiesInDayRange(dateRangeForCurrentViewState).map { (date, activities) in
            (titleForDate(date), activities)
        }
    }
    
    
    /**
     Returns a tuple containing two line chart view data sources based on the current view state.
     Each data source consists of an array of arrays.
     Each array represents all activities performed during index 'I', where I is contexutally interpreted depending on the current view state.
     E.g. if viewState is:
        - .Week:, index I equals day of week.
        - .Month:, index I equals day of month
        - .Year: index I equals month of year
     */
    func lineChartViewDataSourceForCurrentViewState() -> (healthyActivities: [[ActivityModel]], unhealthyActivities: [[ActivityModel]])  {
            let dateRangeForCurrentViewState = 0..<viewState.value.numberOfUnitsInDate(selectedDate.value)
            
            if viewState.value == .Year {
                let allActivitiesInYearPerMonth = activitiesInMonthRange(dateRangeForCurrentViewState).map { (_, activities) in activities }
                return filterHealthyAndUnhealthyActivitiesFromActivities(allActivitiesInYearPerMonth)
            }

        let allActivitiesInWeekOrMonth = activitiesInDayRange(dateRangeForCurrentViewState).map { (_, activities) in activities }
        return filterHealthyAndUnhealthyActivitiesFromActivities(allActivitiesInWeekOrMonth)
    }
    
    
    /**
     Returns the max number of activities allowed for the current view state
     */
    func maxNumberOfActivitiesForCurrentViewState() -> CGFloat {
        switch viewState.value {
        case .Year:
            //Allow a larger number of activities for the yearly view state since it groups all activities per month
            return 150
        default:
            return 7
        }
    }
    
    /**
     Returns the title for the date, based on the view state
     */
    func titleForDate(date: NSDate) -> String {
        switch viewState.value {
        case .Year: return date.formattedMonth()
        default:    return date.formattedDayOfMonth()
        }
    }
    
    /**
     Returns the formatted title for the activity
     */
    func titleForActivity(activity: ActivityModel) -> String {
        switch viewState.value {
        case .Year:      return "\(activity.type) \(activity.date.formattedDayOfMonth())"
        default:         return "\(activity.type)"
        }
    }
    
    /**
     Decreases the selected date by X units, where X is based on the current view state
     */
    mutating func selectPreviousDate() {
        switch viewState.value {
        case .Week:     selectedDate.value = selectedDate.value - 1.week
        case .Month:    selectedDate.value = selectedDate.value - 1.month
        case .Year:     selectedDate.value = selectedDate.value - 1.year
        }
    }
    
    /**
     Increases the selected date by X units, where X is based on the current view state
     */
    mutating func selectNextDate() {
        switch viewState.value {
        case .Week:     selectedDate.value = selectedDate.value + 1.week
        case .Month:    selectedDate.value = selectedDate.value + 1.month
        case .Year:     selectedDate.value = selectedDate.value + 1.year
        }
    }
    
    
    /**
     Returns a formatted date string, based on the selected date and current view state
     */
    func formattedDate() -> String {
        let date = selectedDate.value
        switch viewState.value {
        case .Week:         return "Week \(date.weekOfYear()) of \(date.formattedYear())"
        case .Month:        return "\(date.formattedMonth()) \(date.formattedYear())"
        case .Year:         return "\(date.formattedYear())"
        }
    }
    
    /**
     Returns a formatted left footer label, based on the current view state
     */
    func leftFooterLabelText() -> String {
        switch viewState.value {
        case .Year:         return "Jan"
        case .Month:        return "1"
        case .Week:         return "Sun"
        }
    }
    
    /**
     Returns a formatted right footer label, based on the current view state
     */
    func rightFooterLabelText() -> String {
        switch viewState.value {
        case .Year:         return "Dec"
        case .Month:        return "\(selectedDate.value.endOfMonth.day)"
        case .Week:         return "Sat"
        }
    }
    
    

    
    //MARK: Private
    
    
    /**
    Filters all healthy and all unhealthy activities into two different matrices.
    */
    private func filterHealthyAndUnhealthyActivitiesFromActivities(allActivities: [[ActivityModel]]) ->
        (healthyActivities: [[ActivityModel]], unhealthyActivities: [[ActivityModel]])  {
            let unhealthyActivityTypes: [ActivityType] = [.Candy, .Alcohol, .FastFood]
            let healthy = allActivities.map { array in array.filter { activity in !unhealthyActivityTypes.contains(activity.type) }}
            let unhealthy = allActivities.map { array in array.filter { activity in unhealthyActivityTypes.contains(activity.type) } }
            return (healthy, unhealthy)
    }
    
    /**
     Fetches all activities in the received date range, but filters out dates that don't contain any activities.
     Returns an array of tuples, where the key is the date and the value is all the activities performed during that date.
     */
    private func performedActivitiesInDayRange(dayRange: Range<Int>) -> [ (NSDate, [ActivityModel]) ] {
        return activitiesInDayRange(dayRange).filter { (_, activities) in activities.count > 0 }
    }
    
    /**
     Fetches all activities in the received date range, including all dates (even those that don't contain any activities)
     Returns an array of tuples, where the key is the date and the value is all the activities performed during that date.
     */
    private func activitiesInDayRange(dayRange: Range<Int>) -> [ (NSDate, [ActivityModel]) ] {
        let activities = dayRange
            .map { dayIndex in dateAtIndex(dayIndex) }
            .map { date in (date, activitiesForDate(date)) }
        
        return activities
    }
    
    
    private func performedActivitiesInMonthRange(monthRange: Range<Int>) -> [ (Int, [ActivityModel]) ] {
        return activitiesInMonthRange(monthRange).filter { (_, activities) in activities.count > 0 }
    }
    
    
    /**
     Fetches all activities in the received date range, including all dates (even those that don't contain any activities)
     Returns an array of tuples, where the key is an Int representing monthly index, and the value is all the activities performed during that month.
     */
    private func activitiesInMonthRange(monthRange: Range<Int>) -> [ (Int, [ActivityModel]) ] {
        return monthRange
            .map { monthIndex in
                //Convert each index to a month-date, e.g. 0 == Jan, 1 == Feb, etc
                ViewState.Year.dateFromIndex(monthIndex, date: selectedDate.value)
            }
            .map { monthDate -> [ActivityModel] in activitiesInMonthOfDate(monthDate) }
            
            .enumerate() //Enumerate in order to get month index
            
            .map { (monthIndex, allActivitiesForMonth) in
                //Return an array of tuples containting month index and all activities in that month
                return (monthIndex, allActivitiesForMonth)
        }
    }
    
    /**
     Fetches all activities, for each day, in the month of the received date
     Returns an array of tuples, where each tuple contains each day of the month, and the activities performed for each day.
     */
    private func activitiesInMonthOfDate(date: NSDate) -> [ActivityModel] {
        let nextMonth = (date + 1.month).beginningOfMonth
        let prevMonth = (date - 1.month).endOfMonth
        let predicate = NSPredicate(format: "date > %@ AND date < %@", prevMonth, nextMonth)
        if let activities = db?.objectsOfType(ActivityModel.self, query: predicate) {
            return activities
        }
        
        return []
    }
    
    
    /**
     Fetches all activities for the received date from the database.
     - returns: An array of Activities
     */
    private func activitiesForDate(date: NSDate) -> [ActivityModel] {
        let tomorrow = (date + 1.day).beginningOfDay
        let yesterday = (date - 1.day).endOfDay
        
        let predicate = NSPredicate(format: "date > %@ AND date < %@", yesterday, tomorrow)
        if let activities = db?.objectsOfType(ActivityModel.self, query: predicate) {
            return activities
        }
        
        return []
    }
    
    /**
    Translates the received index to a date based on the currently selected date and view state.
    */
    private func dateAtIndex(index: Int) -> NSDate {
        return viewState.value.dateFromIndex(index, date: selectedDate.value)
    }
}



enum ViewState : Int {
    case Week = 0
    case Month
    case Year
    
    /**
     Returns the number of units in a date, where units is based on the view state.
     E.g:
     - if the view state is Week, the unit is days of week,
     - if the view state is Month, the unit is days of month,
     - if the view state is Year, the unit is months a year
     */
    func numberOfUnitsInDate(date: NSDate) -> Int {
        let numberOfDaysInAWeek: Int = 7
        let numberOfDaysInCurrentMonth: Int = date.endOfMonth.day
        let numberOfMonthsInAYear: Int = 12
        
        switch self {
        case .Week:     return numberOfDaysInAWeek
        case .Month:    return numberOfDaysInCurrentMonth
        case .Year:     return numberOfMonthsInAYear
        }
    }
    
    /**
     Constructs and returns a date object based on the received input.
     
     - parameter index: An index pinpointing a date relative to the received date and the received view state.
     - parameter date: A contextual date, acting as the starting point for the index parameter
     - parameter viewState: A view state, indicating how the index parameter should be translated
     
     Examples:
     - index = 0 (translatedIndex = 1),
     - date = 28-12-2015
     - viewState = Year     --> 28-01-2015 (i.e. January - the first month of the year)
     - viewState = Month    --> 01-12-2015 (i.e. the first day of the month)
     - viewState = Week     --> 27-12-2015 (i.e. Sunday, the first weekday in the 28-12-2015 week range)
     
     */
    func dateFromIndex(index: Int, date: NSDate) -> NSDate {
        
        let translatedIndex = convertIndexToNSCalendarIndex(index)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Weekday, .Month, .Year], fromDate: date)
        
        switch self {
        case .Year:
            components.month = translatedIndex
        case .Month:
            components.day = translatedIndex
        case .Week:
            let weekDayDelta = translatedIndex - components.weekday
            components.day = components.day + weekDayDelta
        }
        
        return calendar.dateFromComponents(components)!
    }
    
    //MARK: Private
    
    /**
    Translates a UI index (i.e. a zero based index) to a NSCalendar index (i.e. a "one-based" index)
    - parameter index: the UI index to be translated
    - returns: the corresponding calendar index
    */
    private func convertIndexToNSCalendarIndex(index: Int) -> Int {
        return Int(index + 1)
    }
}
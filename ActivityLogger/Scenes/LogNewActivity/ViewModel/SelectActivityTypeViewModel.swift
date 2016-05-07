//
//  SelectActivityTypeViewModel.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 30/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import Foundation


struct SelectActivityTypeViewModel {
    
    //MARK: Public
    
    func imageForActivityAtIndex(index: Int) -> String {
        //FIXME: Remove hard coded image names
        let activity = ActivityType(rawValue: index)!
        switch activity {
        case .Squash:       return "squash"
        case .Gym:          return "weights"
        case .HomeWorkout:  return "pushup"
        case .Badminton:    return "badminton"
        case .Run:          return "run"
        case .Football:     return "football"
            
        case .Candy:        return "candy"
        case .FastFood:     return "fastfood"
        case .Alcohol:      return "alcohol"
            
        default:            return "Unknown"
        }
    }
    
    func title() -> String {
        //TODO: Localize
        return "Select type of activity"
    }
    
    func titleForActivityAtIndex(index: Int) -> String {
        let activity = ActivityType(rawValue: index)!
        return activity.description
    }
}
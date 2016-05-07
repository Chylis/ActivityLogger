//
//  ActivityModel.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import Foundation

@objc enum ActivityType: Int {
    case Squash = 0
    case Gym
    case HomeWorkout
    case Badminton
    case Run
    case Football

    case Candy
    case FastFood
    case Alcohol
    
    case Count
}

extension ActivityType: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .Squash:       return "Squash"
        case .Gym:          return "Gym"
        case .HomeWorkout:  return "Home workout"
        case .Badminton:    return "Badminton"
        case .Run:          return "Run"
        case .Football:     return "Football"
            
        case .Candy:        return "Candy"
        case .FastFood:     return "Fast Food"
        case .Alcohol:      return "Alcohol"

        default:            return "default"
        }
    }
}

class ActivityModel : ManagedObject {
    
    dynamic var type = ActivityType.Squash
    dynamic var date = NSDate()
    dynamic var comment = ""
}
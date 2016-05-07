//
//  ManagedObject.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 15/02/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import Foundation
import RealmSwift


/// An object that may be persisted
class ManagedObject : Object {
    
    
    //MARK: Realm specific
    
    dynamic var uniqueId: String = NSUUID().UUIDString
    
    override class func primaryKey() -> String? {
        return "uniqueId"
    }
    
    
    //MARK: Public
    
    /**
    Attempts to persist the managed object in the database.
    - returns: true if successful, else false
    */
    func write() -> Bool {
        guard let db = DatabaseService() else { return false }
        return db.writeObject(self)
    }
}


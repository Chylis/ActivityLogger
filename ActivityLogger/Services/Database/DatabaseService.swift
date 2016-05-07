//
//  DatabaseService.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 15/02/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import Foundation
import RealmSwift


struct DatabaseService {
    
    private let db: Realm
    
    //MARK: Public
    
    init?() {
        do {
            db = try Realm()
        } catch {
            return nil
        }
    }
    
    
    func deleteAll() {
        do {
            db.beginWrite()
            db.deleteAll()
            try db.commitWrite()
        } catch {}
    }
    
    /**
     Attempts to persist the managed object in the database.
     - returns: true if successful, else false
     */
    func writeObject(object: Object) -> Bool {
        do {
            try db.write {
                db.add(object, update: true)
            }
            return true
        } catch {
            return false
        }
    }
    
    
    func objectsOfType<T: Object>(type: T.Type, query: NSPredicate? = nil) -> [T]?  {
        var results: Results<T>? = db.objects(type)

        if let query = query {
            results = results?.filter(query)
        }
        
        return results?.flatMap { $0 } //Flatmap in order to return array rather than Results
    }
}
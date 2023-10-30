//
//  PresenceStorage.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import CloudKit
import Foundation

extension Enrollment {
    func willBePresent(on date: Date) -> Bool {
        return true
    }
}

struct Activity {
    var date: Date
    var title: String?
    
    public static func getNext() -> Self? {
        let now = Date.now
        return Self.getAll().sorted(by: { lhs, rhs in
            return lhs.date <= rhs.date
        }).filter({activity in
            return activity.date >= now
        }).first
    }
    public static func getAll() -> [Self] {
        return []
    }
}

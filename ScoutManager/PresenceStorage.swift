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

struct Activity: Equatable, Hashable, Identifiable {
    var id: Date { get { return self.date }}
    
    var date: Date
    var title: String?
    
    public static func getNext() -> Self? {
        Self.getUpcoming().first
    }
    public static func getUpcoming() -> [Self] {
        let now = Date.now
        return Self.getAll().sorted(by: { lhs, rhs in
            return lhs.date <= rhs.date
        }).filter({activity in
            return activity.date >= now
        })
    }
    public static func getAll() -> [Self] {
        return []
    }
}

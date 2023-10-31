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

struct Activity: Codable, Equatable, Hashable, Identifiable {
    var id: Date { get { return self.date }}
    
    var date: Date
    var title: String?
    
    public static func getNext() async -> Self? {
        await Self.getUpcoming().first
    }
    public static func getUpcoming() async -> [Self] {
        let now = Date.init()
        return await Self.getAll().sorted(by: { lhs, rhs in
            return lhs.date <= rhs.date
        }).filter({activity in
            return activity.date >= now
        })
    }
    public static func getAll() async -> [Self] {
        let results = await withCheckedContinuation { continuation in
            let container = CKContainer.default().privateCloudDatabase
            container.fetch(withQuery: CKQuery(recordType: "Activity", predicate: NSPredicate(format: "TRUEPREDICATE")), completionHandler: continuation.resume)
        }
        guard let data = try? results.get() else {
            return []
        }
        return data.matchResults.compactMap { record -> Activity? in
            guard let record = try? record.1.get() else { return nil}
            return Activity(date: record["date"] as! Date, title: record["title"])
        }
    }
}

//
//  PresenceStorage.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import CloudKit
import Foundation

extension Enrollment {
    func updatePresence(for activity: Activity) async {
        let results = await withCheckedContinuation { continuation in
            let container = CKContainer.default().privateCloudDatabase
            container.fetch(withQuery: CKQuery(recordType: "Presence", predicate: NSPredicate(format: "activity == %@ AND enrollment = %@", CKRecord.ID(recordName: activity.id.uuidString), self.id.uuidString)), completionHandler: continuation.resume)
        }
        guard let data = try? results.get() else {
            return
        }
        if data.matchResults.isEmpty {
            self.willBePresentAtNextActivity = true;
        } else if let record = try? data.matchResults.first?.1.get() {
            self.willBePresentAtNextActivity = record["present"] == 1
        } else {
            self.willBePresentAtNextActivity = true
        }
        /*data.matchResults.compactMap { record in
         guard let record = try? record.1.get() else { return nil}
         //return Activity(date: record["date"] as! Date, title: record["title"])
         }*/
    }
    func updatePresence(for activity: Activity, present: Bool) async {
        let container = CKContainer.default().privateCloudDatabase
        let results = await withCheckedContinuation { continuation in
            container.fetch(withQuery: CKQuery(recordType: "Presence", predicate: NSPredicate(format: "activity == %@ AND enrollment = %@", CKRecord.ID(recordName: activity.id.uuidString), self.id.uuidString)), completionHandler: continuation.resume)
        }
        guard let data = try? results.get() else {
            return
        }
        if !data.matchResults.isEmpty {
            if let id = try? data.matchResults.first?.1.get().recordID {
                try! await container.deleteRecord(withID: id)
            }
        }
        let record = CKRecord(recordType: "Presence")
        record["activity"] = CKRecord.Reference(recordID: CKRecord.ID(recordName: activity.id.uuidString), action: .deleteSelf)
        record["present"] = (present ? 1 : 0) as CKRecordValue
        record["enrollment"] = self.id.uuidString as CKRecordValue
        try! await container.save(record)
    }
}

struct Activity: Codable, Equatable, Hashable, Identifiable {
    var id: UUID
    
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
            guard let record = try? record.1.get() else { return nil }
            return Activity(id: UUID(uuidString: record.recordID.recordName)!, date: record["date"] as! Date, title: record["title"])
        }
    }
}

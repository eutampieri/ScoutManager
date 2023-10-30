//
//  UnitListView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct UnitListView: View {
    @State var enrollments: [Enrollment]?
    @State var openFile = true
    var body: some View {
        NavigationStack {
            List {
                ForEach(enrollments ?? []) { enrollment in
                    HStack {
                        Image(systemName: "person.circle.fill").foregroundColor({
                            if let upcoming = Activity.getNext() {
                                if enrollment.willBePresent(on: upcoming.date) {
                                    return .green
                                } else {
                                    return .red
                                }
                            }
                            else {
                                return Color.primary
                            }
                        }())
                        NavigationLink("\(enrollment.details.name) \(enrollment.details.surname)", value: enrollment)
                    }
                }
            }
            .navigationTitle("La tua unità")
            .navigationDestination(for: Enrollment.self, destination: { enrollment in
                EnrollmentView(enrollment: enrollment)
                
            })
        }
        .fileImporter( isPresented: $openFile, allowedContentTypes: [.item], allowsMultipleSelection: false, onCompletion: {
            (Result) in
            
            do{
                let fileURL = try Result.get()
                let _accessible = fileURL.first!.startAccessingSecurityScopedResource()
                print(fileURL)
                self.enrollments = try loadEnrollments(try Data(contentsOf: fileURL.first!))
                fileURL.first!.stopAccessingSecurityScopedResource()
                self.openFile = false
            }
            catch{
                print("error reading file \(error.localizedDescription)")
            }
            
        })
    }
}

struct UnitListView_Previews: PreviewProvider {
    static var previews: some View {
        UnitListView()
    }
}

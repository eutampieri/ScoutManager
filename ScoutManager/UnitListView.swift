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
    @State var searchString: String = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(enrollments ?? []) { enrollment in
                    if searchString == "" || searchString == "\(enrollment.details.name) \(enrollment.details.surname)" {
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
                            NavigationLink("\(enrollment.details.name) \(enrollment.details.surname)", destination: {
                                EnrollmentView(enrollment: enrollment)
                                
                            })
                        }
                    }
                }
            }
            .searchable(text: $searchString, suggestions: {
                ForEach(enrollments ?? []) { e in
                    if "\(e.details.name) \(e.details.surname)".lowercased().contains(searchString.lowercased()) {
                        Text("\(e.details.name) \(e.details.surname)").searchCompletion("\(e.details.name) \(e.details.surname)")
                    }
                }
            })
            .navigationTitle("La tua unità")
        }
        .fileImporter( isPresented: $openFile, allowedContentTypes: [.item], allowsMultipleSelection: false, onCompletion: {
            (Result) in
            
            do{
                let fileURL = try Result.get()
                let _accessible = fileURL.first!.startAccessingSecurityScopedResource()
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

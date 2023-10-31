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
    @State var upcoming: Activity?
    var body: some View {
        NavigationView {
            List {
                ForEach(enrollments ?? []) { enrollment in
                    if searchString == "" || "\(enrollment.details.name) \(enrollment.details.surname)".lowercased().contains(searchString.lowercased()) {
                        HStack {
                            Image(systemName: "person.circle.fill").foregroundColor({
                                if let upcoming = self.upcoming {
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
            .searchable(text: $searchString)
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
            
        }).task {
            self.upcoming = await Activity.getNext()
        }
    }
}

struct UnitListView_Previews: PreviewProvider {
    static var previews: some View {
        UnitListView()
    }
}

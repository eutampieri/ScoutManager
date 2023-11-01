//
//  UnitListView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct UnitListView: View {
    @State var enrollments: [Enrollment]?
    @State var fileURL: URL?
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
                                if let present = enrollment.willBePresentAtNextActivity {
                                    if present {
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
                        .contextMenu(menuItems: {
                            if let present = enrollment.willBePresentAtNextActivity {
                                if present {
                                    Button {
                                        Task {
                                            await enrollment.updatePresence(for: self.upcoming!, present: false)
                                            await self.refresh()
                                        }
                                    } label: {
                                        Label("Segna come assente", systemImage: "x.circle.fill")
                                            .tint(.red)
                                    }
                                } else {
                                    Button {
                                        Task {
                                            await enrollment.updatePresence(for: self.upcoming!, present: true)
                                            await self.refresh()
                                        }
                                    } label: {
                                        Label("Segna come presente", systemImage: "checkmark.circle.fill")
                                            .tint(.green)
                                    }
                                }
                            }
                        })
                    }
                }
            }
            .searchable(text: $searchString)
            .navigationTitle("La tua unità")
        }
        .fileImporter( isPresented: $openFile, allowedContentTypes: [.item], allowsMultipleSelection: false, onCompletion: {
            (Result) in
            
            do{
                self.fileURL = try Result.get().first
                self.openFile = false
                Task { await self.refresh() }
            }
            catch{
                print("error reading file \(error.localizedDescription)")
            }
            
        }).task {
            await refresh()
        }
        .refreshable {
            await refresh()
        }
    }
    
    func refresh() async {
        if let fileURL = self.fileURL {
            let _accessible = fileURL.startAccessingSecurityScopedResource()
            if let data = try? Data(contentsOf: fileURL) {
                self.enrollments = try? loadEnrollments(data)
            }
            fileURL.stopAccessingSecurityScopedResource()
        }
        
        self.upcoming = await Activity.getNext()
        if let upcoming = self.upcoming {
            await withTaskGroup(of: Void.self) { group in
                for e in self.enrollments ?? [] {
                    group.addTask { await e.updatePresence(for: upcoming) }
                }
            }
            if !(self.enrollments?.isEmpty ?? true) {
                self.enrollments?.append((self.enrollments?.popLast())!)
            }
        }
    }
}

struct UnitListView_Previews: PreviewProvider {
    static var previews: some View {
        UnitListView()
    }
}

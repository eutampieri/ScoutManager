//
//  ContentView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
#if os(macOS)
        NavigationView {
            List {
                NavigationLink(destination: {
                    UnitListView()
                }, label: {
                    Label("Unità", systemImage: "person.2")
                })
                NavigationLink(destination: {
                    ActivityView()
                }, label: {
                    Label("Attività", systemImage: "calendar")
                })

            }
        }
#else
        TabView {
            UnitListView()
                .tabItem({
                    Label("Unità", systemImage: "person.2")
                })
            ActivityView()
                .tabItem({
                    Label("Attività", systemImage: "calendar")
                })
        }
#endif
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

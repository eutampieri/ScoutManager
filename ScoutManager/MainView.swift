//
//  ContentView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

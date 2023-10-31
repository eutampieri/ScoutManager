//
//  ActivityView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct ActivityView: View {
    @State var activities: [Activity] = []
    var body: some View {
        NavigationView {
            List {
                ForEach(activities) { activity in
                    NavigationLink(activity.title ?? "\(activity.date)", destination: {
                        Text("Activity")
                    })
                }
            }.toolbar(content: {
                ToolbarItem(content: {
                    Button(action: {}, label: {
                        Image(systemName: "plus.circle")
                    })
                })
            })
        }.task {
            self.activities = await Activity.getUpcoming()
        }.refreshable {
            self.activities = await Activity.getUpcoming()
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}

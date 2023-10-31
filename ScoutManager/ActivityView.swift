//
//  ActivityView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct ActivityView: View {
    @State var activities: [Activity] = Activity.getUpcoming()
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
                    Text("Plus")
                })
            })
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}

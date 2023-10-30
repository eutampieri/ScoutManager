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
        List {
            ForEach(activities) { activity in
                NavigationLink(activity.title ?? "\(activity.date)", value: activity)
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}

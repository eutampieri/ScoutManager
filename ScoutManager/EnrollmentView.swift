//
//  EnrollmentView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI

struct EnrollmentView: View {
    @State var enrollment: Enrollment
    var body: some View {
        VStack{
            Label("Nome:", systemImage: "")
            Text(enrollment.details.name)
            Label("Cognome:", systemImage: "")
            Text(enrollment.details.surname)
            Label("Codice censimento:", systemImage: "")
            if let agesciId = enrollment.agesciId {
                Text(String(agesciId))
            } else {
                Text("-")
            }
            if let address = enrollment.address {
                Label("Indirizzo:", systemImage: "")
                Text("\(address.street), \(address.town)")
            }
            
        }.navigationTitle("\(enrollment.details.name) \(enrollment.details.surname)")
    }
}

struct EnrollmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnrollmentView(enrollment: Enrollment(id: UUID(), details: Person(name: "Mario", surname: "Rossi"), privacy: (false, false, false), agesciId: nil, address: nil, parents: nil))
    }
}

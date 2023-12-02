//
//  EnrollmentView.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import SwiftUI
import MapKit

struct PersonView: View {
    @State var contact: Person
    
    var body: some View {
        Text("\(contact.name) \(contact.surname)")
            .font(.headline)

        if let email = contact.contacts?.email {
            Text(email)
        }
        if let phoneNumber = contact.contacts?.phone {
            Button(action: {
                if let url = URL(string: "tel://\(phoneNumber)") {
                    //UIApplication.shared.open(url)
                }
            }) {
                Text(phoneNumber)
                    .foregroundColor(.blue)
            }
        }

    }
}

struct EnrollmentView: View {
    @State var enrollment: Enrollment
    @State private var coordinates: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            PersonView(contact: enrollment.details)
            if let address = enrollment.address {
                Text("\(address.street), \(address.town)")
            }
            
            if let coordinates = coordinates {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))))
                    .frame(height: 200)
                    .onAppear {
                        getCoordinates(for: enrollment.address)
                    }
            }
            
            ForEach(enrollment.parents.filter {$0 != nil}.map{$0!}) { parent in
                    PersonView(contact: parent)
            }
            
        }
        .padding()
        .navigationTitle("\(enrollment.details.name) \(enrollment.details.surname)")
    }
    func getCoordinates(for address: PostalAddress?) {
        guard let address = address else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address.street), \(address.town)") { placemarks, error in
            if let location = placemarks?.first?.location?.coordinate {
                self.coordinates = location
            }
        }
        
    }
}

struct EnrollmentView_Previews: PreviewProvider {
    static var previews: some View {
        EnrollmentView(enrollment: Enrollment(id: UUID(), details: Person(name: "Mario", surname: "Rossi"), privacy: (false, false, false), agesciId: nil, address: nil, parents: nil))
    }
}

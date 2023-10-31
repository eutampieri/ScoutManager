//
//  Person.swift
//  ScoutManager
//
//  Created by Eugenio Tampieri on 30/10/23.
//

import Foundation

public enum Sex: Hashable {
    case Male
    case Female
}

public struct Person: Hashable {
    var name: String
    var surname: String
    var dateOfBirth: Date?
    var placeOfBirth: String?
    var fiscalCode: String?
    var sex: Sex?
    var contacts: Contacts?
}

public struct PostalAddress: Codable, Hashable {
    var street: String
    var town: String
}

public struct Contacts: Codable, Hashable {
    var phone: String?
    var email: String?
}

public struct Enrollment {
    var agesciId: Int?
    var details: Person
    var address: PostalAddress?
    var parents: [Person?]
    var privacy: (Bool, Bool, Bool)
}

public struct GenericDecodingError: Error {}

extension Sex: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        let value = try? values.decode(String.self)
        guard let value = value else {
            throw GenericDecodingError()
        }
        switch value {
        case "Male":
            self = .Male
        case "Female":
            self = .Female
        default:
            throw GenericDecodingError()
        }
    }
}

extension Person: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case surname
        case dateOfBirth = "date_of_birth"
        case placeOfBirth = "place_of_birth"
        case fiscalCode = "fiscal_code"
        case sex
        case contacts
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawName = try? values.decode(String.self, forKey: .name)
        let rawSurname = try? values.decode(String.self, forKey: .surname)
        let rawDateOfBirth = try? values.decode([Int].self, forKey: .dateOfBirth)
        let rawPlaceOfBirth = try? values.decode(String.self, forKey: .placeOfBirth)
        let rawFiscalCode = try? values.decode(String.self, forKey: .fiscalCode)
        let rawSex = try? values.decode(Sex.self, forKey: .sex)
        let rawContacts = try? values.decode(Contacts.self, forKey: .contacts)
        
        guard let name = rawName,
              let surname = rawSurname
        else {
            throw GenericDecodingError()
        }
        
        self.name = name
        self.surname = surname
        if let dateOfBirth = rawDateOfBirth {
            self.dateOfBirth = Calendar.current.date(from: DateComponents(year: dateOfBirth[0], month: dateOfBirth[1], day: dateOfBirth[2]))
        }
        self.placeOfBirth = rawPlaceOfBirth
        self.fiscalCode = rawFiscalCode
        self.sex = rawSex
        self.contacts = rawContacts
    }
}


extension Enrollment: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case details
        case address
        case parents
        case privacy
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try? values.decode(Int.self, forKey: .id)
        let rawDetails = try? values.decode(Person.self, forKey: .details)
        let rawAddress = try? values.decode(PostalAddress.self, forKey: .address)
        let rawParents = try? values.decode([Person?].self, forKey: .parents)
        let rawPrivacy = try? values.decode([Bool].self, forKey: .privacy)
        
        guard let details = rawDetails,
              let parents = rawParents,
              let privacy = rawPrivacy
        else {
            throw GenericDecodingError()
        }
        
        self.agesciId = rawId
        self.details = details
        self.address = rawAddress
        self.parents = parents
        self.privacy = (privacy[0], privacy[1], privacy[2])
    }
}

extension Enrollment: Identifiable, Hashable {
    public static func == (lhs: Enrollment, rhs: Enrollment) -> Bool {
        return !(
            lhs.id != rhs.id &&
            lhs.details.fiscalCode != rhs.details.fiscalCode &&
            !(lhs.details.name == rhs.details.name && lhs.details.surname == rhs.details.surname)
        )
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public var id: UUID {
        UUID()
    }
    
}

func loadEnrollments(_ file: Data) throws -> [Enrollment] {
    let decoder = JSONDecoder()
    let json = censimenti_parser_parse([UInt8](file), UInt(file.count))
    let result = String(cString: json!)
    censimenti_parser_parse_free(UnsafeMutablePointer(mutating: json))
    return try decoder.decode([Enrollment].self, from: result.data(using: .utf8)!)
}

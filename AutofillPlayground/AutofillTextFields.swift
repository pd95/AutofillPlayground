//
//  AutofillTextFields.swift
//  AutofillPW
//
//  Created by Philipp on 10.07.22.
//

import SwiftUI

fileprivate enum Field: Hashable, CaseIterable, Identifiable {
    case telephoneNumber
    case emailAddress
    case namePrefix
    case name
    case nameSuffix
    case givenName
    case middleName
    case familyName
    case nickname
    case organizationName
    case jobTitle
    case location
    case fullStreetAddress
    case streetAddressLine1
    case streetAddressLine2
    case addressCity
    case addressCityAndState
    case addressState
    case postalCode
    case countryName

    func next() -> Field {
        var index = Field.allCases.firstIndex(of: self)!
        if index + 1 < Field.allCases.endIndex {
            index += 1
        } else {
            index = 0
        }
        return Field.allCases[index]
    }

    var id: Self { self }
}


extension UITextContentType {
    fileprivate static func from(field: Field) -> Self {
        switch field {
        case .telephoneNumber: return .telephoneNumber
        case .emailAddress: return .emailAddress
        case .namePrefix: return .namePrefix
        case .name: return .name
        case .nameSuffix: return .nameSuffix
        case .givenName: return .givenName
        case .middleName: return .middleName
        case .familyName: return .familyName
        case .nickname: return .nickname
        case .organizationName: return .organizationName
        case .jobTitle: return .jobTitle
        case .location: return .location
        case .fullStreetAddress: return .fullStreetAddress
        case .streetAddressLine1: return .streetAddressLine1
        case .streetAddressLine2: return .streetAddressLine2
        case .addressCity: return .addressCity
        case .addressCityAndState: return .addressCityAndState
        case .addressState: return .addressState
        case .postalCode: return .postalCode
        case .countryName: return .countryName
        }
    }
}

struct AutofillTextFields: View {
    private let contacts: [Field: String] = [
        .namePrefix:        "Name prefix",
        .name:              "Name",
        .nameSuffix:        "Name suffix",
        .givenName:         "Given name",
        .middleName:        "Middle name",
        .familyName:        "Family name",
        .nickname:          "Nickname",
        .organizationName:  "Organization name",
        .jobTitle:          "Job title",
    ]

    private let location: [Field: String] = [
        .location:              "Location",
        .fullStreetAddress:     "Full street address",
        .streetAddressLine1:    "Street address line 1",
        .streetAddressLine2:    "Street address line 2",
        .addressCity:           "Address city",
        .addressCityAndState:   "Address city and state",
        .addressState:          "Address state",
        .postalCode:            "Postal code",
        .countryName:           "Country name",
    ]

    private var contactFields: [Field] {
        Field.allCases.filter({ contacts[$0] != nil })
    }

    private var locationFields: [Field] {
        Field.allCases.filter({ location[$0] != nil })
    }

    @State private var value: [Field: String] = [:]

    @FocusState private var focusedField: Field?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Testing keyboard autofill")
                    .font(.title)

                Text("**Please note: You must have your contact setup to get suggestions!**\nFurther, not all field types seem to provide suggestions event though you filled your contact accordingly. (For example name prefix/suffix, middle name, nickname)")
                    .padding(.top, 1)
                    .foregroundColor(.secondary)

                Section {
                    editField(.telephoneNumber, title: "Telephone number")
                        .keyboardType(.namePhonePad)
                    editField(.emailAddress, title: "Email")
                        .keyboardType(.emailAddress)
                    ForEach(contactFields) { field in
                        editField(field, title: contacts[field]!)
                    }
                } header: {
                    Text("Contacts")
                        .font(.title3)
                        .padding(.top)
                }

                Section {
                    ForEach(locationFields) { field in
                        editField(field, title: location[field]!)
                    }
                } header: {
                    Text("Location Data")
                        .font(.title3)
                        .padding(.top)
                }
            }
            .padding()
        }
        .autocorrectionDisabled(false)
        .keyboardType(.default)
        .textFieldStyle(.roundedBorder)
        .submitLabel(.next)
        .onSubmit(nextField)
        .task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            focusedField = .telephoneNumber
        }
    }

    @ViewBuilder
    private func editField(_ field: Field, title: String) -> some View {
        let binding = Binding {
            value[field, default: ""]
        } set: { newValue, _ in
            value[field] = newValue
        }

        let contentType = field == .middleName ? UITextContentType(rawValue: "middleName") : UITextContentType.from(field: field)

        TextField(title, text: binding)
            .textContentType(contentType)
            .focused($focusedField, equals: field)
    }

    private func nextField() {
        if let oldField = focusedField {
            value[oldField] = value[oldField, default: ""].trimmingCharacters(in: .whitespaces)
            focusedField = oldField.next()
        }
    }
}

struct AutofillTextFields_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Authenticated(model: .init(fakeState: .authenticated(username: "John")))
        }
    }
}

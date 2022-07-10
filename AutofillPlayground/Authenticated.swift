//
//  Authenticated.swift
//  AutofillPlayground
//
//  Created by Philipp on 09.07.22.
//

import SwiftUI

struct Authenticated: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        AutofillTextFields()
            .navigationTitle("Welcome \(model.username)")
            .toolbar {
                Button("Sign out") {
                    model.signOut()
                }
            }
    }
}

struct Authenticated_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Authenticated(model: .init(fakeState: .authenticated(username: "John")))
        }
    }
}

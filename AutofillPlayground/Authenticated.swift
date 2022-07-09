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
        VStack {
            Text(model.username)
                .font(.largeTitle)
                .toolbar {
                    Button("Sign out") {
                        model.signOut()
                    }
                }

            Spacer()
        }
        .navigationTitle("Welcome")
    }
}

struct Authenticated_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Authenticated(model: .init(fakeState: .authenticated(username: "doe")))
        }
    }
}

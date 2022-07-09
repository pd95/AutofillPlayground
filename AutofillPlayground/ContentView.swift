//
//  ContentView.swift
//  AutofillPlayground
//
//  Created by Philipp on 09.07.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = ViewModel()

    var body: some View {
        NavigationView {
            Group {
                if model.isSignedIn {
                    Authenticated(model: model)
                } else {
                    SignIn(model: model)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

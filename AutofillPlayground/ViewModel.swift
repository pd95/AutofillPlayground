//
//  ViewModel.swift
//  AutofillPlayground
//
//  Created by Philipp on 09.07.22.
//

import SwiftUI

@MainActor
class ViewModel: ObservableObject {
    enum State: Equatable {
        case anonymous
        case authenticated(username: String)
    }

    @Published var state = State.anonymous

    var isSignedIn: Bool {
        state != .anonymous
    }

    var username: String {
        guard case .authenticated(username: let username) = state else {
            return ""
        }
        return username
    }

    func signUp(username: String, password: String) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        state = .authenticated(username: username)
    }

    func signIn(username: String, password: String) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        state = .authenticated(username: username)
    }

    func signOut() {
        state = .anonymous
    }
}


extension ViewModel {
    convenience init(fakeState: State) {
        self.init()
        state = fakeState
    }
}

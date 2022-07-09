//
//  SignIn.swift
//  AutofillPlayground
//
//  Created by Philipp on 09.07.22.
//

import SwiftUI

struct SignIn: View {
    @ObservedObject var model: ViewModel

    enum Field {
        case username, password
    }

    @FocusState private var focusedField: Field?

    @State private var username = ""
    @State private var password = ""
    @State private var isSignInProgress = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .textContentType(.username)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.send)

            Button(action: submit) {
                HStack(spacing: 10) {
                    Text("Sign in")
                        .font(.headline)

                    if isSignInProgress {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)

            NavigationLink("Create an account?") {
                SignUp(model: model)
            }
            Spacer()

        }
        .padding()
        .navigationTitle("Sign in to YC")
        .textFieldStyle(.roundedBorder)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .onSubmit(submit)
        .disabled(isSignInProgress)
        .task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            focusedField = .username
        }
    }

    private func submit() {
        if username.isEmpty {
            focusedField = .username
        } else if password.isEmpty {
            focusedField = .password
        } else {
            focusedField = nil
            isSignInProgress = true
            Task {
                await model.signIn(username: username, password: password)
                isSignInProgress = false
            }
        }
    }
}


struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignIn(model: .init())
        }
    }
}

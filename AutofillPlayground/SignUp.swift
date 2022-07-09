//
//  SignUp.swift
//  AutofillPlayground
//
//  Created by Philipp on 09.07.22.
//

import SwiftUI

struct SignUp: View {
    @ObservedObject var model: ViewModel

    enum Field {
        case username, password, confirmPassword
    }

    @FocusState private var focusedField: Field?

    @State private var username = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var isSignUpProgress = false

    var body: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .textContentType(.username)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)

            SecureField("Confirm Password", text: $confirmedPassword)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .confirmPassword)
                .submitLabel(.send)

            Button(action: submit) {
                HStack(spacing: 10) {
                    Text("Sign Up")
                        .font(.headline)

                    if isSignUpProgress {
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Sign up for YC")
        .textFieldStyle(.roundedBorder)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .onSubmit(submit)
        .disabled(isSignUpProgress)
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
        } else if confirmedPassword.isEmpty || password != confirmedPassword {
            focusedField = .confirmPassword
        } else {
            focusedField = nil
            isSignUpProgress = true
            Task {
                await model.signUp(username: username, password: password)
                isSignUpProgress = false
            }
        }
    }
}
struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUp(model: .init())
        }
    }
}

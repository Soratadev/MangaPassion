//
//  AccountView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import SwiftUI

struct AccountView: View {
    @Environment(SessionViewModel.self) private var session

    var body: some View {
        NavigationStack {
            Group {
                if session.isRestoringSession {
                    ProgressView()
                } else if session.isLoggedIn {
                    LoggedInView()
                } else {
                    AuthForm()
                }
            }
            .navigationTitle("Account")
        }
    }
}

private struct LoggedInView: View {
    @Environment(SessionViewModel.self) private var session

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.largeTitle)
                .foregroundStyle(.green)
            Text("You are logged in.")
            Button("Log out", role: .destructive) {
                session.logout()
            }
        }
    }
}

private struct AuthForm: View {
    @Environment(SessionViewModel.self) private var session
    @State private var email = ""
    @State private var password = ""
    @State private var mode: Mode = .login
    @State private var isSubmitting = false
    @State private var registrationSucceeded = false

    private enum Mode: String, CaseIterable {
        case login = "Log In"
        case register = "Register"
        
        var label: LocalizedStringResource {
            switch self {
                case .login: "Log In"
                case .register: "Register"
            }
        }
    }

    var body: some View {
        Form {
            Picker("Mode", selection: $mode) {
                ForEach(Mode.allCases, id: \.self) { Text($0.label).tag($0) }
            }
            .pickerStyle(.segmented)

            Section {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                SecureField("Password (min. 8 characters)", text: $password)
            }

            if let errorMessage = session.errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }
            if registrationSucceeded {
                Text("Account created. You can now log in.").foregroundStyle(.green)
            }

            Section {
                Button(mode.label) {
                    Task { await submit() }
                }
                .disabled(isSubmitting || email.isEmpty || password.isEmpty)
            }
        }
    }

    private func submit() async {
        isSubmitting = true
        registrationSucceeded = false
        switch mode {
        case .login:
            await session.login(email: email, password: password)
        case .register:
            let success = await session.register(email: email, password: password)
            if success {
                registrationSucceeded = true
                mode = .login
            }
        }
        isSubmitting = false
    }
}

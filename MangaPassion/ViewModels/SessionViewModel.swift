//
//  SessionViewModel.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import Foundation

@Observable
final class SessionViewModel {
    private(set) var token: String?
    private(set) var isRestoringSession = true
    var errorMessage: String?

    private let accountService: AccountService
    private let tokenStore: KeychainTokenStore

    var isLoggedIn: Bool { token != nil }

    init(accountService: AccountService = AccountService(), tokenStore: KeychainTokenStore = KeychainTokenStore()) {
        self.accountService = accountService
        self.tokenStore = tokenStore
    }

    func restoreSession() async {
        defer { isRestoringSession = false }
        guard let storedToken = tokenStore.load() else { return }
        do {
            let renewedToken = try await accountService.renewToken(storedToken)
            token = renewedToken
            tokenStore.save(renewedToken)
        } catch {
            tokenStore.delete()
            token = nil
        }
    }

    func register(email: String, password: String) async -> Bool {
        errorMessage = nil
        do {
            try await accountService.register(UserCredentials(email: email, password: password))
            return true
        } catch {
            errorMessage = message(for: error)
            return false
        }
    }

    func login(email: String, password: String) async {
        errorMessage = nil
        do {
            let newToken = try await accountService.login(UserCredentials(email: email, password: password))
            token = newToken
            tokenStore.save(newToken)
        } catch {
            errorMessage = message(for: error)
        }
    }

    func logout() {
        tokenStore.delete()
        token = nil
    }

    private func message(for error: Error) -> String {
        if case APIError.httpError(_, let reason) = error, let reason {
            return reason
        }
        return String(localized: "Something went wrong. Please try again.", comment: "Generic auth error fallback")
    }
}

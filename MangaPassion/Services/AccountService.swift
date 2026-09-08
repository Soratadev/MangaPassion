//
//  AccountService.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import Foundation

struct AccountService {
    func register(_ credentials: UserCredentials) async throws {
        let body = try JSONEncoder().encode(credentials)
        try await APIClient.shared.requestWithoutContent(
            path: "/users",
            method: .post,
            headers: ["App-Token": APIConstants.appToken],
            body: body
        )
    }

    func login(_ credentials: UserCredentials) async throws -> String {
        let raw = "\(credentials.email):\(credentials.password)"
        let base64 = Data(raw.utf8).base64EncodedString()
        let response: TokenResponse = try await APIClient.shared.request(
            path: "/users/login",
            method: .post,
            headers: ["Authorization": "Basic \(base64)"]
        )
        return response.token
    }

    func renewToken(_ token: String) async throws -> String {
        let response: TokenResponse = try await APIClient.shared.request(
            path: "/users/renew",
            method: .post,
            headers: ["Authorization": "Bearer \(token)"]
        )
        return response.token
    }
}

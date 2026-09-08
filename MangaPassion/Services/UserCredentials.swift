//
//  UserCredentials.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
struct UserCredentials: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Decodable {
    let token: String
}

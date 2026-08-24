//
//  Author.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
import Foundation

struct Author: Codable, Identifiable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    let role: String
}

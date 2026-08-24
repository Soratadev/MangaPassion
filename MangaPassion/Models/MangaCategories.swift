//
//  MangaCategories.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
import Foundation

struct Genre: Codable, Identifiable, Hashable {
    let id: UUID
    let genre: String
}

struct Theme: Codable, Identifiable, Hashable {
    let id: UUID
    let theme: String
}

struct Demographic: Codable, Identifiable, Hashable {
    let id: UUID
    let demographic: String
}

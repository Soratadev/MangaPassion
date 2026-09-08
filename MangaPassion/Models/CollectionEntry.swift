//
//  CollectionEntry.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import Foundation

struct CollectionEntry: Codable, Identifiable, Hashable {
    let id: UUID
    let manga: Manga
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}

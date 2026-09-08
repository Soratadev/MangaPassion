//
//  UserMangaCollectionRequest.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
struct UserMangaCollectionRequest: Codable {
    var manga: Int
    var completeCollection: Bool
    var volumesOwned: [Int]
    var readingVolume: Int?
}

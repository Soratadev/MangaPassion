//
//  CollectionService.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import Foundation

struct CollectionService {
    func addOrUpdate(_ request: UserMangaCollectionRequest, token: String) async throws {
        let body = try JSONEncoder().encode(request)
        try await APIClient.shared.requestWithoutContent(
            path: "/collection/manga",
            method: .post,
            headers: ["Authorization": "Bearer \(token)"],
            body: body
        )
    }

    func fetchCollection(token: String) async throws -> [CollectionEntry] {
        try await APIClient.shared.request(
            path: "/collection/manga",
            headers: ["Authorization": "Bearer \(token)"]
        )
    }

    func fetchEntry(mangaID: Int, token: String) async throws -> CollectionEntry {
        try await APIClient.shared.request(
            path: "/collection/manga/\(mangaID)",
            headers: ["Authorization": "Bearer \(token)"]
        )
    }

    func remove(mangaID: Int, token: String) async throws {
        try await APIClient.shared.requestWithoutContent(
            path: "/collection/manga/\(mangaID)",
            method: .delete,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
}

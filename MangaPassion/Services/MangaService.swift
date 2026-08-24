//
//  MangaService.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
import Foundation

struct MangaService {
    func fetchMangas(page: Int = 1, per: Int = 10) async throws -> PagedResponse<Manga> {
        try await APIClient.shared.request(
            path: "/list/mangas",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(per))
            ]
        )
    }
}

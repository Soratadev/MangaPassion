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

extension MangaService {
    func fetchGenres() async throws -> [String] {
        try await APIClient.shared.request(path: "/list/genres")
    }
    
    func fetchThemes() async throws -> [String] {
        try await APIClient.shared.request(path: "/list/themes")
    }
    
    func fetchDemographics() async throws -> [String] {
        try await APIClient.shared.request(path: "/list/demographics")
    }
    
    func fetchMangas(filteredBy category: MangaCategory, page: Int = 1, per: Int = 20) async throws -> PagedResponse<Manga> {
        try await APIClient.shared.request(
            path: category.path,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(per))
            ]
        )
    }
}

extension MangaService {
    func searchMangas(beginningWith text: String) async throws -> [Manga] {
        try await APIClient.shared.request(path: "/search/mangasBeginsWith/\(text)")
    }

    func searchMangas(containing text: String, page: Int = 1, per: Int = 20) async throws -> PagedResponse<Manga> {
        try await APIClient.shared.request(
            path: "/search/mangasContains/\(text)",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(per))
            ]
        )
    }

    func searchAuthors(matching text: String) async throws -> [Author] {
        try await APIClient.shared.request(path: "/search/author/\(text)")
    }

    func fetchManga(id: Int) async throws -> Manga {
        try await APIClient.shared.request(path: "/search/manga/\(id)")
    }

    func searchMangas(customSearch: CustomSearch, page: Int = 1, per: Int = 20) async throws -> PagedResponse<Manga> {
        let body = try JSONEncoder().encode(customSearch)
        return try await APIClient.shared.request(
            path: "/search/manga",
            method: .post,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(per))
            ],
            body: body
        )
    }
}

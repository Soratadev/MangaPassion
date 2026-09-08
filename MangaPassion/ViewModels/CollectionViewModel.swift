//
//  CollectionViewModel.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import Foundation

@Observable
final class CollectionViewModel {
    private(set) var entries: [CollectionEntry] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let service: CollectionService

    init(service: CollectionService = CollectionService()) {
        self.service = service
    }

    func entry(forMangaID mangaID: Int) -> CollectionEntry? {
        entries.first { $0.manga.id == mangaID }
    }

    func loadCollection(token: String) async {
        isLoading = true
        errorMessage = nil
        do {
            entries = try await service.fetchCollection(token: token)
        } catch {
            errorMessage = message(for: error)
        }
        isLoading = false
    }

    func save(_ request: UserMangaCollectionRequest, token: String) async {
        errorMessage = nil
        do {
            try await service.addOrUpdate(request, token: token)
            await loadCollection(token: token)
        } catch {
            errorMessage = message(for: error)
        }
    }

    func remove(mangaID: Int, token: String) async {
        errorMessage = nil
        do {
            try await service.remove(mangaID: mangaID, token: token)
            entries.removeAll { $0.manga.id == mangaID }
        } catch {
            errorMessage = message(for: error)
        }
    }

    func clear() {
        entries = []
        errorMessage = nil
    }

    private func message(for error: Error) -> String {
        if case APIError.httpError(_, let reason) = error, let reason {
            return reason
        }
        return "Something went wrong. Please try again."
    }
}

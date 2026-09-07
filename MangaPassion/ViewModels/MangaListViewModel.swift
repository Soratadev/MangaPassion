//
//  MangaListViewModel.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 24/08/2026.
//
import Foundation

@Observable
final class MangaListViewModel {
    enum Source: Equatable {
        case all
        case category(MangaCategory)
        case search(String)
    }

    private(set) var mangas: [Manga] = []
    private(set) var isLoading = false
    var errorMessage: String?
    private(set) var source: Source = .all

    private let service: MangaService
    private var currentPage = 1
    private let perPage = 20
    private var totalMangas = 0

    init(service: MangaService = MangaService()) {
        self.service = service
    }

    var canLoadMore: Bool {
        mangas.count < totalMangas
    }

    func setSource(_ source: Source) async {
        guard source != self.source else { return }
        self.source = source
        await loadFirstPage()
    }

    func loadFirstPage() async {
        currentPage = 1
        mangas = []
        await loadCurrentPage()
    }

    func loadNextPageIfNeeded(currentItem manga: Manga) async {
        guard manga == mangas.last, canLoadMore, !isLoading else { return }
        currentPage += 1
        await loadCurrentPage()
    }

    private func loadCurrentPage() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: PagedResponse<Manga>
            switch source {
            case .all:
                response = try await service.fetchMangas(page: currentPage, per: perPage)
            case .category(let category):
                response = try await service.fetchMangas(filteredBy: category, page: currentPage, per: perPage)
            case .search(let text):
                response = try await service.searchMangas(containing: text, page: currentPage, per: perPage)
            }
            mangas.append(contentsOf: response.items)
            totalMangas = response.metadata.total
        } catch {
            errorMessage = String(
                localized: "The list of manga could not be loaded.",
                comment: "Error shown when the manga list fails to load."
            )
        }
        isLoading = false
    }
}

//
//  MangaListViewModel.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 24/08/2026.
//
import Foundation

@Observable
final class MangaListViewModel {
    private(set) var mangas: [Manga] = []
    private(set) var isLoading: Bool = false
    var errorMessage: String?
    
    private let service: MangaService
    private var currentPage = 1
    private let perPage = 20
    private var totalMangas = 0
    private var category: MangaCategory?
    
    init(service: MangaService = MangaService()) {
        self.service = service
    }
    
    var canLoadMore: Bool {
        mangas.count < totalMangas
    }
    
    private func loadCurrentPage() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: PagedResponse<Manga>
            if let category {
                response = try await service.fetchMangas(filteredBy: category, page: currentPage, per: perPage)
            } else {
                response = try await service.fetchMangas(page: currentPage, per: perPage)
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
    
    func setCategory(_ category: MangaCategory?) async {
            guard category != self.category else { return }
            self.category = category
            await loadFirstPage()
        }
}


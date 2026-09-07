//
//  AdvancedSearchViewModel.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 07/09/2026.
//
import Foundation

@Observable
final class AdvancedSearchViewModel {
    var title = ""
    var authorFirstName = ""
    var authorLastName = ""
    var selectedGenres: Set<String> = []
    var selectedThemes: Set<String> = []
    var selectedDemographics: Set<String> = []
    var matchAnywhereInText = true

    private(set) var results: [Manga] = []
    private(set) var isLoading = false
    private(set) var hasSearched = false
    var errorMessage: String?

    private let service: MangaService
    private var currentPage = 1
    private let perPage = 20
    private var totalResults = 0

    init(service: MangaService = MangaService()) {
        self.service = service
    }

    var canLoadMore: Bool { results.count < totalResults }

    private var currentSearch: CustomSearch {
        CustomSearch(
            searchTitle: title.isEmpty ? nil : title,
            searchAuthorFirstName: authorFirstName.isEmpty ? nil : authorFirstName,
            searchAuthorLastName: authorLastName.isEmpty ? nil : authorLastName,
            searchGenres: selectedGenres.isEmpty ? nil : Array(selectedGenres),
            searchThemes: selectedThemes.isEmpty ? nil : Array(selectedThemes),
            searchDemographics: selectedDemographics.isEmpty ? nil : Array(selectedDemographics),
            searchContains: matchAnywhereInText
        )
    }

    func search() async {
        hasSearched = true
        currentPage = 1
        results = []
        await loadCurrentPage()
    }

    func loadNextPageIfNeeded(currentItem manga: Manga) async {
        guard manga == results.last, canLoadMore, !isLoading else { return }
        currentPage += 1
        await loadCurrentPage()
    }

    private func loadCurrentPage() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await service.searchMangas(customSearch: currentSearch, page: currentPage, per: perPage)
            results.append(contentsOf: response.items)
            totalResults = response.metadata.total
        } catch {
            errorMessage = "The search could not be completed."
        }
        isLoading = false
    }
}

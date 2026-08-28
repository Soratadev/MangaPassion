//
//  FilterOptionsViewModel.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 28/08/2026.
//
import Foundation

@Observable
final class FilterOptionsViewModel {
    private(set) var genres: [String] = []
    private(set) var themes: [String] = []
    private(set) var demographics: [String] = []
    private(set) var isLoading = false
    
    private let service: MangaService
    
    init(service: MangaService = MangaService()) {
        self.service = service
    }
    
    func loadIfNeeded() async {
        guard genres.isEmpty, !isLoading else { return }
        isLoading = true
        do {
            async let genresResult = service.fetchGenres()
            async let themesResult = service.fetchThemes()
            async let demographicsResult = service.fetchDemographics()
            
            (genres, themes, demographics) = try await (genresResult, themesResult, demographicsResult)
        } catch {
            // si falla, los filtros aparecen vacíos.
        }
        isLoading = false
    }
}

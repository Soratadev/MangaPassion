//
//  MangaPassionTests.swift
//  MangaPassionTests
//
//  Created by Alejandro Ortega García on 04/08/2026.
//

import Testing
@testable import MangaPassion

struct MangaPassionTests {

    @Test func fetchMangasReturnsResults() async throws {
        let service = MangaService()
        let response = try await service.fetchMangas(page: 1, per: 5)
        #expect(response.items.count == 5)
        #expect(response.metadata.total > 0)
    }

}

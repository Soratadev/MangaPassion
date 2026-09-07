//
//  CustomSearch.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 07/09/2026.
//
// Services/CustomSearch.swift
import Foundation

struct CustomSearch: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool
}

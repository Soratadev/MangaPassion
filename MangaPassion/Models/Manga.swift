//
//  Manga.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
import Foundation

struct Manga: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    
    let authors: [Author]
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]
    
    let startDate: Date?
    let endDate: Date?
    let score: Double?
    let status: MangaStatus
    let chapters: Int?
    let volumes: Int?
    
    let mainPicture: URL?
    let synopsis: String?
    let background: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case id, title, titleEnglish, titleJapanese
        case authors, genres, themes, demographics
        case startDate, endDate, score, status, chapters, volumes
        case mainPicture
        case synopsis = "sypnosis"
        case background, url
    }
}

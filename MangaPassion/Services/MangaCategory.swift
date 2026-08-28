//
//  MangaCategory.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 28/08/2026.
//
import Foundation

enum MangaCategory: Hashable {
    case genre(String)
    case theme(String)
    case demographic(String)
    
    var displayValue: String {
        switch self {
        case .genre(let value), .theme(let value), .demographic(let value): value
        }
    }
    
    var path: String {
        switch self {
        case .genre(let value): "/list/mangaByGenre/\(value)"
        case .theme(let value): "/list/mangaByTheme/\(value)"
        case .demographic(let value): "/list/mangaByDemographic/\(value)"
        }
    }
}

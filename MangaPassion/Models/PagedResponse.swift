//
//  PagedResponse.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
struct Metadata: Codable, Hashable {
    let total: Int
    let page: Int
    let per: Int
}

struct PagedResponse<Item: Codable & Hashable>: Codable {
    let items: [Item]
    let metadata: Metadata
}

//
//  MangaStatus.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
import Foundation

enum MangaStatus: Decodable, Hashable {
    case finished
    case currentlyPublishing
    case onHiatus
    case discontinued
    case unknown(String)
    
    init (from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        switch raw {
            case "finished": self = .finished
            case "currently_publishing": self = .currentlyPublishing
            case "on_hiatus": self = .onHiatus
            case "discontinued": self = .discontinued
            default: self = .unknown(raw)
        }
    }
}

extension MangaStatus: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .finished: try container.encode("finished")
            case .currentlyPublishing: try container.encode("currently_publishing")
            case .onHiatus: try container.encode("on_hiatus")
            case .discontinued: try container.encode("discontinued")
            case .unknown(let raw): try container.encode(raw)
        }
    }
}

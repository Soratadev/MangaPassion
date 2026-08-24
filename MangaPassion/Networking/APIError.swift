//
//  APIError.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 12/08/2026.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
}

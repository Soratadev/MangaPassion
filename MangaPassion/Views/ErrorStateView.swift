//
//  ErrorStateView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import SwiftUI

struct ErrorStateView: View {
    let message: String
    var retry: (() async -> Void)? = nil

    var body: some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            if let retry {
                Button("Retry") {
                    Task { await retry() }
                }
            }
        }
    }
}

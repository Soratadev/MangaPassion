//
//  FilterSheet.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 28/08/2026.
//
import SwiftUI

struct FilterSheet: View {
    let options: FilterOptionsViewModel
    let activeCategory: MangaCategory?
    let onSelect: (MangaCategory?) -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("All mangas (no filter)") {
                        onSelect(nil)
                    }
                }
                Section("Genres") {
                    ForEach(options.genres, id: \.self) { genre in
                        filterRow(label: genre, category: .genre(genre))
                    }
                }
                Section("Themes") {
                    ForEach(options.themes, id: \.self) { theme in
                        filterRow(label: theme, category: .theme(theme))
                    }
                }
                Section("Demographics") {
                    ForEach(options.demographics, id: \.self) { demographic in
                        filterRow(label: demographic, category: .demographic(demographic))
                    }
                }
            }
            .navigationTitle("Filter by category")
            .task { await options.loadIfNeeded() }
        }
    }

    private func filterRow(label: String, category: MangaCategory) -> some View {
        Button {
            onSelect(category)
        } label: {
            HStack {
                Text(label)
                Spacer()
                if activeCategory == category {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

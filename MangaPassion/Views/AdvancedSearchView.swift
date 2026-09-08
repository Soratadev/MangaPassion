//
//  AdvancedSearchView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 07/09/2026.
//
import SwiftUI

struct AdvancedSearchView: View {
    @State private var viewModel = AdvancedSearchViewModel()
    @State private var filterOptions = FilterOptionsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Title & author") {
                    TextField("Title", text: $viewModel.title)
                    TextField("Author first name", text: $viewModel.authorFirstName)
                    TextField("Author last name", text: $viewModel.authorLastName)
                    Toggle("Match anywhere in text", isOn: $viewModel.matchAnywhereInText)
                }

                categorySection("Genres", options: filterOptions.genres, selection: $viewModel.selectedGenres)
                categorySection("Themes", options: filterOptions.themes, selection: $viewModel.selectedThemes)
                categorySection("Demographics", options: filterOptions.demographics, selection: $viewModel.selectedDemographics)

                Section {
                    Text("Genre, theme and demographic filters match manga in ANY of the categories you select, not all of them at once. This is how the search API combines these criteria.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button("Search") {
                        Task { await viewModel.search() }
                    }
                }

                if viewModel.hasSearched {
                    Section("Results") {
                        ForEach(viewModel.results) { manga in
                            NavigationLink(value: manga) {
                                MangaRow(manga: manga)
                            }
                            .task { await viewModel.loadNextPageIfNeeded(currentItem: manga) }
                        }
                        if viewModel.results.isEmpty && !viewModel.isLoading {
                            Text("No results.").foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
            }
            .navigationTitle("Advanced Search")
            .task { await filterOptions.loadIfNeeded() }
        }
    }

    private func categorySection(_ title: LocalizedStringKey, options: [String], selection: Binding<Set<String>>) -> some View {
        Section(title) {
            ForEach(options, id: \.self) { option in
                Button {
                    if selection.wrappedValue.contains(option) {
                        selection.wrappedValue.remove(option)
                    } else {
                        selection.wrappedValue.insert(option)
                    }
                } label: {
                    HStack {
                        Text(option)
                        Spacer()
                        if selection.wrappedValue.contains(option) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
    }
}

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
    @State private var selectedManga: Manga?

    var body: some View {
        NavigationSplitView {
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
                            Button {
                                selectedManga = manga
                            } label: {
                                MangaRow(manga: manga)
                            }
                            .buttonStyle(.plain)
                            .task { await viewModel.loadNextPageIfNeeded(currentItem: manga) }
                        }
                        if viewModel.results.isEmpty && !viewModel.isLoading {
                            Text("No results.").foregroundStyle(.secondary)
                        }
                        if let message = viewModel.errorMessage {
                            Text(message).foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Advanced Search")
            .task { await filterOptions.loadIfNeeded() }
        } detail: {
            if let selectedManga {
                MangaDetailView(manga: selectedManga)
            } else {
                ContentUnavailableView("Select a manga", systemImage: "book.closed")
            }
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

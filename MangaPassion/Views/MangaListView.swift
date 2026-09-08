//
//  MangaListView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 24/08/2026.
//
import SwiftUI

enum DisplayMode: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
    
    var label: LocalizedStringResource {
        switch self {
        case .list: "List"
        case .grid: "Grid"
        }
    }
}

struct MangaListView: View {
    @State private var viewModel = MangaListViewModel()
    @State private var filterOptions = FilterOptionsViewModel()
    @State private var displayMode: DisplayMode = .list
    @State private var showingFilters = false
    @State private var searchText = ""

    private var activeCategory: MangaCategory? {
        if case .category(let category) = viewModel.source { category } else { nil }
    }

    private var navigationTitleText: String {
        switch viewModel.source {
        case .all: "My Mangas"
        case .category(let category): category.displayValue
        case .search: "Search results"
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                switch displayMode {
                case .list:
                    List(viewModel.mangas) { manga in
                        NavigationLink(value: manga) {
                            MangaRow(manga: manga)
                        }
                        .task { await viewModel.loadNextPageIfNeeded(currentItem: manga) }
                    }
                case .grid:
                    MangaGridView(mangas: viewModel.mangas) { manga in
                        await viewModel.loadNextPageIfNeeded(currentItem: manga)
                    }
                }
            }
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(manga: manga)
            }
            .navigationTitle(navigationTitleText)
            .overlay {
                if viewModel.isLoading && viewModel.mangas.isEmpty {
                    ProgressView()
                } else if let message = viewModel.errorMessage, viewModel.mangas.isEmpty {
                    ContentUnavailableView(message, systemImage: "wifi.slash")
                }
            }
            .searchable(text: $searchText, prompt: "Search manga titles")
            .task(id: searchText) {
                if searchText.isEmpty {
                    if case .search = viewModel.source {
                        await viewModel.setSource(.all)
                    }
                    return
                }
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled else { return }
                await viewModel.setSource(.search(searchText))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Display", selection: $displayMode) {
                        ForEach(DisplayMode.allCases, id: \.self) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Image(systemName: activeCategory == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterSheet(
                    options: filterOptions,
                    activeCategory: activeCategory,
                    onSelect: { category in
                        showingFilters = false
                        Task {
                            await viewModel.setSource(category.map(MangaListViewModel.Source.category) ?? .all)
                        }
                    }
                )
            }
            .task {
                if viewModel.mangas.isEmpty {
                    await viewModel.loadFirstPage()
                }
            }
        }
    }
}

struct MangaRow: View {
    let manga: Manga

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: manga.mainPicture) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading) {
                Text(manga.title).font(.headline)
                if let score = manga.score {
                    Text("⭑ \(score, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    MangaListView()
}

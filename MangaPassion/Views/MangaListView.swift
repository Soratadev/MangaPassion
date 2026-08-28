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
}

struct MangaListView: View {
    @State private var viewModel = MangaListViewModel()
    @State private var filterOptions = FilterOptionsViewModel()
    @State private var displayMode: DisplayMode = .list
    @State private var showingFilters = false
    @State private var activeCategory: MangaCategory?
    
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
            .navigationTitle(activeCategory?.displayValue ?? "My Mangas")
            .overlay {
                if viewModel.isLoading && viewModel.mangas.isEmpty {
                    ProgressView()
                } else if let message = viewModel.errorMessage, viewModel.mangas.isEmpty {
                    ContentUnavailableView(message, systemImage: "wifi.slash")
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Display", selection: $displayMode) {
                        ForEach(DisplayMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
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
                        activeCategory = category
                        showingFilters = false
                        Task { await viewModel.setCategory(category) }
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

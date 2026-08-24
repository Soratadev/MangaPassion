//
//  MangaListView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 24/08/2026.
//
import SwiftUI

struct MangaListView: View {
    @State private var viewModel = MangaListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.mangas) { manga in
                MangaRow(manga: manga)
                    .task {
                        await viewModel.loadNextPageIfNeeded(currentItem: manga)
                    }
            }
            .navigationTitle("My Mangas")
            .overlay {
                if viewModel.isLoading && viewModel.mangas.isEmpty {
                    ProgressView()
                } else if let message = viewModel.errorMessage, viewModel.mangas.isEmpty {
                    ContentUnavailableView(message, systemImage: "wifi.slash")
                }
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

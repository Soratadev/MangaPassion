//
//  MangaGridView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 28/08/2026.
//
import SwiftUI

struct MangaGridView: View {
    let mangas: [Manga]
    let onAppearItem: (Manga) async -> Void
    
    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaGridCell(manga: manga)
                    }
                    .buttonStyle(.plain)
                    .task { await onAppearItem(manga) }
                }
            }
            .padding()
        }
    }
}

struct MangaGridCell: View {
    let manga: Manga
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: manga.mainPicture) { image in
                image.resizable().aspectRatio(2/3, contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .aspectRatio(2/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(manga.title)
                .font(.caption)
                .lineLimit(2)
        }
    }
}

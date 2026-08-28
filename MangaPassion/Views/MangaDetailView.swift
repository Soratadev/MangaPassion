//
//  MangaDetailView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 28/08/2026.
//
import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                infoRow
                
                if !manga.authors.isEmpty {
                    authorsSection
                }
                
                TagList(title: "Genres", items: manga.genres.map(\.genre))
                TagList(title: "Themes", items: manga.themes.map(\.theme))
                TagList(title: "Demographics", items: manga.demographics.map(\.demographic))
                
                if let synopsis = manga.synopsis {
                    textSection(title: "Synopsis", text: synopsis)
                }
                
                if let background = manga.background {
                    textSection(title: "Background", text: background)
                }
            }
            .padding()
        }
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var header: some View {
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: manga.mainPicture) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 120, height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 4) {
                    Text(manga.title).font(.title2).bold()
                    if let english = manga.titleEnglish, english != manga.title {
                        Text(english).font(.subheadline).foregroundStyle(.secondary)
                    }
                    if let japanese = manga.titleJapanese {
                        Text(japanese).font(.subheadline).foregroundStyle(.secondary)
                    }
                    if let score = manga.score {
                        Label(String(format: "%.2f", score), systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
        }
    
    private var infoRow: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(statusText)
                if let chapters = manga.chapters {
                    Text("Chapters: \(chapters)")
                }
                if let volumes = manga.volumes {
                    Text("Volumes: \(volumes)")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    
    private var statusText: String {
        switch manga.status {
        case .finished: "Finished"
        case .currentlyPublishing: "Currently publishing"
        case .onHiatus: "On hiatus"
        case .discontinued: "Discontinued"
        case .unknown(let raw): raw
        }
    }
    
    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Authors").font(.headline)
            ForEach(manga.authors) { author in
                Text("\(author.firstName) \(author.lastName) — \(author.role)")
                    .font(.subheadline)
            }
        }
    }
    
    private func textSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(text).font(.body)
        }
    }
}

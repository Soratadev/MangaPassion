//
//  CollectionView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import SwiftUI

struct CollectionView: View {
    @Environment(SessionViewModel.self) private var session
    @Environment(CollectionViewModel.self) private var collection
    @State private var selectedManga: Manga?

    var body: some View {
        NavigationSplitView {
            sidebarContent
                .navigationTitle("My Collection")
                .refreshable {
                    if let token = session.token {
                        await collection.loadCollection(token: token)
                    }
                }
        } detail: {
            if let selectedManga {
                MangaDetailView(manga: selectedManga)
            } else {
                ContentUnavailableView("Select a manga", systemImage: "book.closed")
            }
        }
    }

    @ViewBuilder
    private var sidebarContent: some View {
        if !session.isLoggedIn {
            ContentUnavailableView("Log in to see your collection", systemImage: "person.crop.circle.badge.exclamationmark")
        } else if collection.isLoading && collection.entries.isEmpty {
            ProgressView()
        } else if let message = collection.errorMessage, collection.entries.isEmpty {
            ErrorStateView(message: message) {
                if let token = session.token {
                    await collection.loadCollection(token: token)
                }
            }
        } else if collection.entries.isEmpty {
            ContentUnavailableView("Your collection is empty", systemImage: "books.vertical")
        } else {
            List(selection: $selectedManga) {
                ForEach(collection.entries) { entry in
                    CollectionRow(entry: entry)
                        .tag(entry.manga)
                }
                .onDelete { indexSet in
                    Task {
                        guard let token = session.token else { return }
                        for index in indexSet {
                            await collection.remove(mangaID: collection.entries[index].manga.id, token: token)
                        }
                    }
                }
            }
        }
    }
}

struct CollectionRow: View {
    let entry: CollectionEntry

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: entry.manga.mainPicture) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 50, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.manga.title).font(.headline)
                if entry.completeCollection {
                    Label("Complete collection", systemImage: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Text("\(entry.volumesOwned.count) volumes owned")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let readingVolume = entry.readingVolume {
                    Text("Reading volume \(readingVolume)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

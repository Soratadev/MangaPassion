//
//  CollectionSection.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 08/09/2026.
//
import SwiftUI

struct CollectionSection: View {
    let manga: Manga

    @Environment(SessionViewModel.self) private var session
    @Environment(CollectionViewModel.self) private var collection
    @State private var volumesOwnedCount = 0
    @State private var readingVolume = 0
    @State private var hasCompleteCollection = false
    @State private var isSaving = false

    private var existingEntry: CollectionEntry? {
        collection.entry(forMangaID: manga.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("My Collection").font(.headline)

            Stepper("Volumes owned: \(volumesOwnedCount)", value: $volumesOwnedCount, in: 0...(manga.volumes ?? 200))
            Stepper("Reading volume: \(readingVolume)", value: $readingVolume, in: 0...max(volumesOwnedCount, 1))
            Toggle("I own the complete collection", isOn: $hasCompleteCollection)

            Button(existingEntry == nil ? "Add to my collection" : "Update") {
                Task { await save() }
            }
            .disabled(isSaving)

            if existingEntry != nil {
                Button("Remove from my collection", role: .destructive) {
                    Task { await remove() }
                }
            }

            if let errorMessage = collection.errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.caption)
            }
        }
        .task(id: existingEntry) {
            if let entry = existingEntry {
                volumesOwnedCount = entry.volumesOwned.count
                readingVolume = entry.readingVolume ?? 0
                hasCompleteCollection = entry.completeCollection
            }
        }
    }

    private func save() async {
        guard let token = session.token else { return }
        isSaving = true
        let request = UserMangaCollectionRequest(
            manga: manga.id,
            completeCollection: hasCompleteCollection,
            volumesOwned: volumesOwnedCount > 0 ? Array(1...volumesOwnedCount) : [],
            readingVolume: readingVolume > 0 ? readingVolume : nil
        )
        await collection.save(request, token: token)
        isSaving = false
    }

    private func remove() async {
        guard let token = session.token else { return }
        await collection.remove(mangaID: manga.id, token: token)
        volumesOwnedCount = 0
        readingVolume = 0
        hasCompleteCollection = false
    }
}

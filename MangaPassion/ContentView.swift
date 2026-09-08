//
//  ContentView.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 04/08/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(SessionViewModel.self) private var session
    @Environment(CollectionViewModel.self) private var collection

    var body: some View {
        TabView {
            MangaListView()
                .tabItem { Label("Browse", systemImage: "books.vertical") }

            AdvancedSearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            CollectionView()
                .tabItem { Label("My Collection", systemImage: "books.vertical.fill") }

            AccountView()
                .tabItem { Label("Account", systemImage: "person.circle") }
        }
        .task(id: session.token) {
            if let token = session.token {
                await collection.loadCollection(token: token)
            } else {
                collection.clear()
            }
        }
    }
}

#Preview {
    ContentView()
}

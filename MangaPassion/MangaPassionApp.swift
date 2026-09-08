//
//  MangaPassionApp.swift
//  MangaPassion
//
//  Created by Alejandro Ortega García on 04/08/2026.
//

import SwiftUI

@main
struct MangaPassionApp: App {
    @State private var session = SessionViewModel()
    @State private var collection = CollectionViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
                .environment(collection)
                .task { await session.restoreSession() }
        }
    }
}

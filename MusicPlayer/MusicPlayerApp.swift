//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 30.05.2025.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                BrowseView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Browse")
                    }
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                LibraryView()
                    .tabItem {
                        Image(systemName: "books.vertical.fill")
                        Text("Library")
                    }
                HistoryView()
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
            }
        }
    }
}

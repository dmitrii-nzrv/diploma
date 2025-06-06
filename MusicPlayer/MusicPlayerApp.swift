//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 30.05.2025.
//

import Firebase
import FirebaseCore
import FirebaseAuth
import SwiftUI

@main
struct MusicPlayerApp: App {
    @StateObject private var authController = AuthController()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authController)
        }
    }
}


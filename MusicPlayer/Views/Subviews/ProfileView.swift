//
//  ProfileView.swift
//  MusicPlayer
//
//  Created by Dmitrii Nazarov on 06.06.2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authController: AuthController
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                Text("Profile")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                if let email = authController.userEmail {
                    Text(email)
                        .foregroundColor(.gray)
                        .font(.title3)
                }
                Button(action: {
                    authController.signOut()
                }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                        .bold()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                }
            }
        }
    }
}

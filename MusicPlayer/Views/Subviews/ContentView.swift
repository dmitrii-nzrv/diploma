//
//  ContentView.swift
//  BookTalks
//
//  Created by Dmitrii Nazarov on 07.05.2025.
//
import Firebase
import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authController: AuthController
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        if authController.isLoggedIn {
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
                ProfileView()
                    .tabItem {
                        Image(systemName: "clock.fill")
                        Text("Profile")
                    }
            }
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack{
            //Color.black
            Color.topBG
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.bottomBG, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            VStack(spacing: 20){
                Text("Welcome")
                    .foregroundStyle(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
//
                TextField("Email", text: $email)
                    .foregroundStyle(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundStyle(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(.white)
                
                SecureField("", text: $password)
                    .foregroundStyle(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundStyle(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundStyle(.white)
                
                Button {
                    authController.register(email: email, password: password)
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing)))
                        .foregroundStyle(.white)
                }
                .padding(.top)
                .offset(y:100)
                
                Button {
                    authController.login(email: email, password: password)
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundStyle(.white)
                }
                .padding(.top)
                .offset(y:110)
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

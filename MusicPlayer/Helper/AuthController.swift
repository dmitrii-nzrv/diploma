//
//  AuthController.swift
//  BookTalks
//
//  Created by Dmitrii Nazarov on 23.05.2025.
//
import Foundation
import FirebaseAuth

class AuthController: ObservableObject {
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    var userEmail: String? {
        Auth.auth().currentUser?.email
    }

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Register error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
} 

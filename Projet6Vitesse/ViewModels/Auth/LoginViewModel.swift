//
//  LoginViewModel.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    private let keychainService: KeychainServiceProtocol
    private let appState: AppStateViewModel
    
    init(authService: AuthServiceProtocol = AuthService(),
         keychainService: KeychainServiceProtocol = KeychainService(),
         appState: AppStateViewModel) {
        self.authService = authService
        self.keychainService = keychainService
        self.appState = appState
    }
    
    func login() async {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        do {
            let response = try await authService.login(email: email, password: password)
            try keychainService.save(token: response.token)
            appState.isAuthenticated = true
            appState.isAdmin = response.isAdmin
            errorMessage = nil
        } catch {
            errorMessage = "Invalid credentials"
            appState.isAuthenticated = false
        }
    }
}

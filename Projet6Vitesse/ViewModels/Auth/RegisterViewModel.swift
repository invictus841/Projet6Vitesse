//
//  RegisterViewModel.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var shouldDismiss = false
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func register() async {
        guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords don't match"
            return
        }
        
        do {
            let user = User(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            
            try await authService.register(user: user)
            successMessage = "Registration successful!"
            shouldDismiss = true
            
        } catch {
            errorMessage = "Registration failed"
        }
    }
}

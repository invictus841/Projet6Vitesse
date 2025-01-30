//
//  MockAuthService.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    let shouldFail: Bool
    
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        if shouldFail {
            throw NetworkError.unauthorized
        }
        return AuthResponse(token: "fake-token", isAdmin: false)
    }
    
    func register(user: User) async throws {
        if shouldFail {
            throw NetworkError.serverError("Registration failed")
        }
    }
}

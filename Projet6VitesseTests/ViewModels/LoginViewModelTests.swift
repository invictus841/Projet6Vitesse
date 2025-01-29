//
//  LoginViewModelTests.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import XCTest
@testable import Projet6Vitesse

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    func test_login_withValidCredentials_shouldAuthenticate() async throws {

        let mockAuthService = MockAuthService()
        let mockKeychain = MockKeychainService()
        let appState = AppStateViewModel()
        let viewModel = LoginViewModel(
            authService: mockAuthService,
            keychainService: mockKeychain,
            appState: appState
        )
        
        viewModel.email = "admin@vitesse.com"
        viewModel.password = "test123"
        

        await viewModel.login()
        

        XCTAssertTrue(appState.isAuthenticated)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(try mockKeychain.getToken())
    }
    
    func test_login_withInvalidCredentials_shouldShowError() async throws {

        let mockAuthService = MockAuthService(shouldFail: true)
        let appState = AppStateViewModel()
        let viewModel = LoginViewModel(
            authService: mockAuthService,
            keychainService: MockKeychainService(),
            appState: appState
        )
        
        viewModel.email = "wrong@vitesse.com"
        viewModel.password = "wrongpass"
        

        await viewModel.login()
        

        XCTAssertFalse(appState.isAuthenticated)
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials")
    }
    
    func test_login_withEmptyFields_shouldShowError() async throws {

        let appState = AppStateViewModel()
        let viewModel = LoginViewModel(
            authService: MockAuthService(),
            keychainService: MockKeychainService(),
            appState: appState
        )
        
        viewModel.email = ""
        viewModel.password = ""
        

        await viewModel.login()
        

        XCTAssertFalse(appState.isAuthenticated)
        XCTAssertEqual(viewModel.errorMessage, "Please fill all fields")
    }
}

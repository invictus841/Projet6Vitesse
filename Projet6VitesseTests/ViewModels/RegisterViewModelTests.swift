//
//  RegisterViewModelTests.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import XCTest
@testable import Projet6Vitesse

@MainActor
final class RegisterViewModelTests: XCTestCase {
    
    func test_register_withValidData_shouldSucceed() async throws {

        let mockAuthService = MockAuthService()
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        

        await viewModel.register()
        

        XCTAssertNotNil(viewModel.successMessage)
        XCTAssertTrue(viewModel.shouldDismiss)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_register_withMismatchPasswords_shouldShowError() async throws {

        let mockAuthService = MockAuthService()
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.confirmPassword = "differentPassword"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        

        await viewModel.register()
        

        XCTAssertEqual(viewModel.errorMessage, "Passwords don't match")
        XCTAssertFalse(viewModel.shouldDismiss)
    }
    
    func test_register_withEmptyFields_shouldShowError() async throws {

        let mockAuthService = MockAuthService()
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        viewModel.email = ""
        viewModel.password = ""
        viewModel.confirmPassword = ""
        viewModel.firstName = ""
        viewModel.lastName = ""
        

        await viewModel.register()
        

        XCTAssertEqual(viewModel.errorMessage, "Please fill all fields")
        XCTAssertFalse(viewModel.shouldDismiss)
    }
    
    func test_register_whenServiceFails_shouldShowError() async throws {

        let mockAuthService = MockAuthService(shouldFail: true)
        let viewModel = RegisterViewModel(authService: mockAuthService)
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        

        await viewModel.register()
        

        XCTAssertEqual(viewModel.errorMessage, "Registration failed")
        XCTAssertFalse(viewModel.shouldDismiss)
    }
}

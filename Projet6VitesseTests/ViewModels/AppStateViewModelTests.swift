//
//  AppStateViewModelTests.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import XCTest
@testable import Projet6Vitesse

@MainActor
final class AppStateViewModelTests: XCTestCase {
    
    func test_logout_shouldResetStateAndDeleteToken() throws {
        // Given
        let mockKeychain = MockKeychainService()
        try mockKeychain.save(token: "test-token")
        let viewModel = AppStateViewModel(keychainService: mockKeychain)
        viewModel.isAuthenticated = true
        viewModel.isAdmin = true
        
        // When
        viewModel.logout()
        
        // Then
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertFalse(viewModel.isAdmin)
        XCTAssertNil(try mockKeychain.getToken())
    }
}

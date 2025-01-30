//
//  CandidateDetailViewModelTests.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import XCTest
@testable import Projet6Vitesse

@MainActor
final class CandidateDetailViewModelTests: XCTestCase {
    
    func test_init_withNilOptionalValues_shouldSetEmptyStrings() async throws {
        // Given
        let candidateWithNils = Candidate(
            id: "1",
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            phone: nil,
            note: nil,
            linkedinURL: nil,
            isFavorite: false,
            isSelected: false
        )
        
        // When
        let viewModel = CandidateDetailViewModel(
            candidate: candidateWithNils,
            isAdmin: true,
            candidateService: MockCandidateService()
        )
        
        // Then
        XCTAssertEqual(viewModel.editedPhone, "")
        XCTAssertEqual(viewModel.editedNote, "")
        XCTAssertEqual(viewModel.editedLinkedinURL, "")
    }
    
    func test_toggleFavorite_whenAdmin_shouldUpdateCandidateStatus() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: true,
            candidateService: mockService
        )
        
        // When
        await viewModel.toggleFavorite()
        
        // Then
        XCTAssertTrue(viewModel.candidate.isFavorite)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_toggleFavorite_whenNotAdmin_shouldNotCallService() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: false,
            candidateService: mockService
        )
        
        // When
        await viewModel.toggleFavorite()
        
        // Then
        XCTAssertEqual(viewModel.candidate.isFavorite, Candidate.sample.isFavorite)
    }
    
    func test_toggleFavorite_whenFails_shouldShowError() async throws {
        // Given
        let mockService = MockCandidateService(shouldFailFetch: true)
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: true,
            candidateService: mockService
        )
        
        // When
        await viewModel.toggleFavorite()
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Failed to toggle favorite")
    }
    
    func test_saveChanges_withEmptyOptionalFields_shouldSaveAsNil() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: true,
            candidateService: mockService
        )
        
        // When
        viewModel.isEditing = true
        viewModel.editedPhone = ""
        viewModel.editedNote = ""
        viewModel.editedLinkedinURL = ""
        await viewModel.saveChanges()
        
        // Then
        XCTAssertNil(viewModel.candidate.phone)
        XCTAssertNil(viewModel.candidate.note)
        XCTAssertNil(viewModel.candidate.linkedinURL)
    }
    
    func test_saveChanges_whenAdmin_shouldUpdateCandidateInfo() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: true,
            candidateService: mockService
        )
        
        // When
        viewModel.editedEmail = "new@email.com"
        viewModel.editedPhone = "9999999"
        await viewModel.saveChanges()
        
        // Then
        XCTAssertEqual(viewModel.candidate.email, "new@email.com")
        XCTAssertEqual(viewModel.candidate.phone, "9999999")
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_saveChanges_whenNotAdmin_shouldNotUpdate() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: false,
            candidateService: mockService
        )
        let originalEmail = viewModel.candidate.email
        
        // When
        viewModel.editedEmail = "new@email.com"
        await viewModel.saveChanges()
        
        // Then
        XCTAssertEqual(viewModel.candidate.email, originalEmail)
    }
    
    func test_saveChanges_whenFails_shouldShowError() async throws {
        // Given
        let mockService = MockCandidateService(shouldFailFetch: true)
        let viewModel = CandidateDetailViewModel(
            candidate: .sample,
            isAdmin: true,
            candidateService: mockService
        )
        
        // When
        viewModel.isEditing = true
        viewModel.editedEmail = "new@email.com"
        await viewModel.saveChanges()
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Failed to save changes")
        XCTAssertTrue(viewModel.isEditing)
    }
}

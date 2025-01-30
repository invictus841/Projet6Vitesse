//
//  CandidatesViewModelTests.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import XCTest
@testable import Projet6Vitesse

@MainActor
final class CandidatesViewModelTests: XCTestCase {
    
    func test_filteredCandidates_whenShowFavoritesOnly_shouldFilterFavorites() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        await viewModel.fetchCandidates()
        
        // When
        viewModel.showFavoritesOnly = true
        
        // Then
        XCTAssertTrue(viewModel.filteredCandidates.allSatisfy { $0.isFavorite })
    }
    
    func test_fetchCandidates_whenSuccessful_shouldUpdateList() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        
        // When
        await viewModel.fetchCandidates()
        
        // Then
        XCTAssertEqual(viewModel.candidates.count, 2)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchCandidates_whenFails_shouldShowError() async throws {
        // Given
        let mockService = MockCandidateService(shouldFailFetch: true)
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        
        // When
        await viewModel.fetchCandidates()
        
        // Then
        XCTAssertTrue(viewModel.candidates.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load candidates")
    }
    
    func test_searchText_shouldFilterCandidates() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        await viewModel.fetchCandidates()
        
        // When
        viewModel.searchText = "John"
        
        // Then
        XCTAssertEqual(viewModel.filteredCandidates.count, 1)
        XCTAssertEqual(viewModel.filteredCandidates.first?.firstName, "John")
    }
    
    func test_toggleSelection_shouldUpdateCandidateState() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        await viewModel.fetchCandidates()
        let candidateId = viewModel.candidates.first!.id
        
        // When
        viewModel.toggleSelection(for: candidateId)
        
        // Then
        XCTAssertTrue(viewModel.candidates.first!.isSelected)
        XCTAssertEqual(viewModel.selectedCandidatesCount, 1)
    }
    
    func test_deleteCandidates_whenSuccessful_shouldRefreshList() async throws {
        // Given
        let mockService = MockCandidateService()
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        await viewModel.fetchCandidates()
        viewModel.toggleSelection(for: viewModel.candidates.first!.id)
        
        // When
        await viewModel.deleteCandidates()
        
        // Then
        XCTAssertEqual(viewModel.candidates.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_deleteCandidates_whenFails_shouldShowError() async throws {
        // Given
        let mockService = MockCandidateService(shouldFailDelete: true)
        let viewModel = CandidatesViewModel(candidateService: mockService, isAdmin: true)
        await viewModel.fetchCandidates()
        viewModel.toggleSelection(for: viewModel.candidates.first!.id)
        
        // When
        await viewModel.deleteCandidates()
        
        // Then
        XCTAssertEqual(viewModel.errorMessage, "Failed to delete candidates")
    }
}

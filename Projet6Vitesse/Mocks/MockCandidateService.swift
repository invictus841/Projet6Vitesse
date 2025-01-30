//
//  MockCandidateService.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import Foundation

class MockCandidateService: CandidateServiceProtocol {
    let shouldFailFetch: Bool
    let shouldFailDelete: Bool
    private var candidates: [Candidate] = [
        Candidate(
            id: "1",
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            phone: "123456789",
            note: "Note test",
            linkedinURL: nil,
            isFavorite: false,
            isSelected: false
        ),
        Candidate(
            id: "2",
            firstName: "Jane",
            lastName: "Smith",
            email: "jane@example.com",
            phone: "987654321",
            note: "Note test",
            linkedinURL: nil,
            isFavorite: true,
            isSelected: false
        )
    ]
    
    init(shouldFailFetch: Bool = false, shouldFailDelete: Bool = false) {
        self.shouldFailFetch = shouldFailFetch
        self.shouldFailDelete = shouldFailDelete
    }
    
    func fetchCandidates() async throws -> [Candidate] {
        if shouldFailFetch {
            throw NetworkError.serverError("Failed to fetch")
        }
        return candidates
    }
    
    func updateCandidate(_ candidate: Candidate) async throws -> Candidate {
        if shouldFailFetch {
            throw NetworkError.serverError("Failed to update")
        }
        return candidate
    }
    
    func toggleFavorite(candidateId: String) async throws -> Candidate {
        if shouldFailFetch {
            throw NetworkError.serverError("Failed to toggle favorite")
        }
        return Candidate(
            id: candidateId,
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            phone: nil,
            note: nil,
            linkedinURL: nil,
            isFavorite: true,
            isSelected: false
        )
    }
    
    func deleteCandidates(ids: [String]) async throws {
        if shouldFailDelete {
            throw NetworkError.serverError("Failed to delete")
        }
        candidates.removeAll { ids.contains($0.id) }
    }
}

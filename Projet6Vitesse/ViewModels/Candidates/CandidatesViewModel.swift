//
//  CandidatesViewModel.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

@MainActor
class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var searchText = ""
    @Published var showFavoritesOnly = false
    @Published var isEditing = false
    @Published var errorMessage: String?
    
    private let candidateService: CandidateServiceProtocol
    let isAdmin: Bool
    
    init(candidateService: CandidateServiceProtocol = CandidateService(), isAdmin: Bool = false) {
        self.candidateService = candidateService
        self.isAdmin = isAdmin
    }
    
    var filteredCandidates: [Candidate] {
        var result = candidates
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        return result
    }
    
    func fetchCandidates() async {
        do {
            candidates = try await candidateService.fetchCandidates()
        } catch {
            errorMessage = "Failed to load candidates"
        }
    }
    
    func toggleSelection(for id: String) {
        if let index = candidates.firstIndex(where: { $0.id == id }) {
            candidates[index].isSelected.toggle()
        }
    }
    
    var selectedCandidatesCount: Int {
        candidates.filter { $0.isSelected }.count
    }
    
    func deleteCandidates() async {
        let selectedIds = candidates.filter { $0.isSelected }.map { $0.id }
        do {
            try await candidateService.deleteCandidates(ids: selectedIds)
            await fetchCandidates()
        } catch {
            errorMessage = "Failed to delete candidates"
        }
    }
}

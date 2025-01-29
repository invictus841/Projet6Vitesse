//
//  CandidateDetailViewModel.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

@MainActor
class CandidateDetailViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isEditing = false
    @Published var errorMessage: String?
    
    @Published var editedEmail = ""
    @Published var editedPhone = ""
    @Published var editedLinkedinURL = ""
    @Published var editedNote = ""
    
    let isAdmin: Bool
    private let candidateService: CandidateServiceProtocol
    
    init(candidate: Candidate,
         isAdmin: Bool,
         candidateService: CandidateServiceProtocol = CandidateService()) {
        self.candidate = candidate
        self.isAdmin = isAdmin
        self.candidateService = candidateService
        
        self.editedEmail = candidate.email
        self.editedPhone = candidate.phone ?? ""
        self.editedLinkedinURL = candidate.linkedinURL ?? ""
        self.editedNote = candidate.note ?? ""
    }
    
    func toggleFavorite() async {
        guard isAdmin else { return }
        
        do {
            candidate = try await candidateService.toggleFavorite(candidateId: candidate.id)
            errorMessage = nil
        } catch {
            print("Debug toggle favorite error: \(error)")
            errorMessage = "Failed to toggle favorite"
        }
    }
    
    func saveChanges() async {
        guard isAdmin else { return }
        
        let updatedCandidate = Candidate(
            id: candidate.id,
            firstName: candidate.firstName,
            lastName: candidate.lastName,
            email: editedEmail,
            phone: editedPhone.isEmpty ? nil : editedPhone,
            note: editedNote.isEmpty ? nil : editedNote,
            linkedinURL: editedLinkedinURL.isEmpty ? nil : editedLinkedinURL,
            isFavorite: candidate.isFavorite,
            isSelected: candidate.isSelected
        )
        
        do {
            candidate = try await candidateService.updateCandidate(updatedCandidate)
            isEditing = false
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save changes"
        }
    }
}

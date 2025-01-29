//
//  CandidateService.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

protocol CandidateServiceProtocol {
    func fetchCandidates() async throws -> [Candidate]
    func updateCandidate(_ candidate: Candidate) async throws -> Candidate
    func toggleFavorite(candidateId: String) async throws -> Candidate
    func deleteCandidates(ids: [String]) async throws
}

struct CandidateService: CandidateServiceProtocol {
    private let baseURL = "http://127.0.0.1:8080"
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
    }
    
    private func getHeaders() throws -> [String: String] {
        guard let token = try keychainService.getToken() else {
            throw NetworkError.unauthorized
        }
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }
    
    func fetchCandidates() async throws -> [Candidate] {
        guard let url = URL(string: "\(baseURL)/candidate") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = try getHeaders()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Invalid response")
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode([Candidate].self, from: data)
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
        }
    }
    
    func toggleFavorite(candidateId: String) async throws -> Candidate {
        guard let url = URL(string: "\(baseURL)/candidate/\(candidateId)/favorite") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = try getHeaders()
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Invalid response")
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(Candidate.self, from: data)
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.serverError("Admin rights required")
        default:
            throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
        }
    }
    
    func updateCandidate(_ candidate: Candidate) async throws -> Candidate {
        guard let url = URL(string: "\(baseURL)/candidate/\(candidate.id)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = try getHeaders()
        
        let updateData = [
            "email": candidate.email,
            "phone": candidate.phone,
            "linkedinURL": candidate.linkedinURL,
            "note": candidate.note,
            "firstName": candidate.firstName,
            "lastName": candidate.lastName
        ]
        
        request.httpBody = try JSONEncoder().encode(updateData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Invalid response")
        }
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(Candidate.self, from: data)
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
        }
    }
    
    func deleteCandidates(ids: [String]) async throws {
        guard let token = try keychainService.getToken() else {
            throw NetworkError.unauthorized
        }
        
        for id in ids {
            guard let url = URL(string: "\(baseURL)/candidate/\(id)") else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.serverError("Invalid response")
            }
            
            switch httpResponse.statusCode {
            case 200:
                continue
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.serverError("Status code: \(httpResponse.statusCode)")
            }
        }
    }
}

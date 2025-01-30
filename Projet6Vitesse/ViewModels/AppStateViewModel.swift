//
//  AppStateViewModel.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

@MainActor
class AppStateViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
    }
    
    func logout() {
        try? keychainService.deleteToken()
        isAuthenticated = false
        isAdmin = false
    }
}

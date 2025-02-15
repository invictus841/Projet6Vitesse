//
//  AppStateViewModel.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import Foundation

class AppStateViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
    }
    
    func logout() {
        do {
            try keychainService.deleteToken()
        } catch {
            print("Erreur lors de la suppression du token : \(error)")
        }
        isAuthenticated = false
        isAdmin = false
    }
}

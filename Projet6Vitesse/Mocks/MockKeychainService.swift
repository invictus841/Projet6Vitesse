//
//  MockKeychainService.swift
//  Projet6VitesseTests
//
//  Created by Alexandre Talatinian on 30/01/2025.
//

import Foundation

class MockKeychainService: KeychainServiceProtocol {
    private var token: String?
    
    func save(token: String) throws {
        self.token = token
    }
    
    func getToken() throws -> String? {
        return token
    }
    
    func deleteToken() throws {
        token = nil
    }
}

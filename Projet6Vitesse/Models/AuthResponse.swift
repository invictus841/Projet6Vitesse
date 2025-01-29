//
//  AuthResponse.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

struct AuthResponse: Decodable {
    let token: String
    let isAdmin: Bool
}

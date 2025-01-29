//
//  Candidate.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

struct Candidate: Decodable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, phone, linkedinURL, note, isFavorite
    }
    
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let note: String?
    let linkedinURL: String?
    let isFavorite: Bool
    
    var isSelected: Bool = false
    var name: String {
        "\(firstName) \(lastName)"
    }
    
    static let sample = Candidate(
            id: "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1",
            firstName: "John",
            lastName: "Doe",
            email: "john.doe@example.com",
            phone: "+33 6 12 34 56 78",
            note: "Bon candidat avec 3 ans d'expérience en dev iOS",
            linkedinURL: "https://linkedin.com/in/johndoe",
            isFavorite: true,
            isSelected: false
        )
}

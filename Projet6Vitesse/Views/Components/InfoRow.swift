//
//  InfoRow.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    InfoRow(label: "label", value: "value")
}

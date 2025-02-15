//
//  CustomTextField.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    let label: String
    @Binding var text: String
    var isSecure: Bool = false
    var contentType: UITextContentType? = .none
    var isEditing = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .tint(isEditing ? .green : .blue)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundStyle(isEditing ? .green : .blue)
                }
            }
            .modifier(TextFieldModifier())
            .textContentType(isSecure ? .none : contentType)
        }
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .textInputAutocapitalization(.never)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}

struct LinkedInField: View {
    let label: String
    let url: String
    let isEditing: Bool
    @Binding var editedText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
            
            if isEditing {
                TextField("LinkedIn URL", text: $editedText)
                    .foregroundStyle(.green)
                    .modifier(TextFieldModifier())
            } else {
                Button {
                    if let url = URL(string: url), url.scheme != nil {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(url.isEmpty ? "Not provided" : url)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .modifier(TextFieldModifier())
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomTextField(
            placeholder: "Enter your email",
            label: "Email",
            text: .constant("")
        )
        
        CustomTextField(
            placeholder: "Enter your password",
            label: "Password",
            text: .constant(""),
            isSecure: true
        )
        
        LinkedInField(label: "Test", url: "www.test.com", isEditing: false, editedText: .constant("test"))
    }
    .padding()
}

//
//  RegisterView.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Create Account")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                CustomTextField(
                    placeholder: "Enter your first name",
                    label: "First Name",
                    text: $viewModel.firstName
                )
                
                CustomTextField(
                    placeholder: "Enter your last name",
                    label: "Last Name",
                    text: $viewModel.lastName
                )
                
                CustomTextField(
                    placeholder: "Enter your email",
                    label: "Email",
                    text: $viewModel.email,
                    contentType: .emailAddress
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                
                CustomTextField(
                    placeholder: "Enter your password",
                    label: "Password",
                    text: $viewModel.password,
                    isSecure: true
                )
                
                CustomTextField(
                    placeholder: "Confirm your password",
                    label: "Confirm Password",
                    text: $viewModel.confirmPassword,
                    isSecure: true
                )
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                
                if let success = viewModel.successMessage {
                    Text(success)
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                }
                
                PrimaryButton(title: "Create Account") {
                    Task {
                        await viewModel.register()
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 60)
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: RegisterViewModel())
}

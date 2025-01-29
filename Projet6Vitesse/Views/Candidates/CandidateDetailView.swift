//
//  CandidateDetailView.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import SwiftUI

struct CandidateDetailView: View {
    @ObservedObject var viewModel: CandidateDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(viewModel.candidate.firstName) \(viewModel.candidate.lastName)")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    if viewModel.isAdmin {
                        Button {
                            Task {
                                await viewModel.toggleFavorite()
                            }
                        } label: {
                            Image(systemName: viewModel.candidate.isFavorite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                
                VStack(spacing: 15) {
                    CustomTextField(
                        placeholder: "Email",
                        label: "Email",
                        text: viewModel.isEditing ? $viewModel.editedEmail : .constant(viewModel.candidate.email),
                        isEditing: viewModel.isEditing
                    )
                    
                    CustomTextField(
                        placeholder: "Phone",
                        label: "Phone",
                        text: viewModel.isEditing ? $viewModel.editedPhone : .constant(viewModel.candidate.phone ?? "Not provided"),
                        isEditing: viewModel.isEditing
                    )
                    
                    CustomTextField(
                        placeholder: "LinkedIn URL",
                        label: "LinkedIn",
                        text: viewModel.isEditing ? $viewModel.editedLinkedinURL : .constant(viewModel.candidate.linkedinURL ?? "Not provided"),
                        isEditing: viewModel.isEditing
                    )
                    
                    CustomTextField(
                        placeholder: "Note",
                        label: "Note",
                        text: viewModel.isEditing ? $viewModel.editedNote : .constant(viewModel.candidate.note ?? "No notes"),
                        isEditing: viewModel.isEditing
                    )
                    
                    if viewModel.isEditing {
                        Button("Save") {
                            Task {
                                await viewModel.saveChanges()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.isAdmin {
                Button(viewModel.isEditing ? "Cancel" : "Edit") {
                    viewModel.isEditing.toggle()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CandidateDetailView(viewModel: CandidateDetailViewModel(candidate: Candidate.sample, isAdmin: true))
    }
}

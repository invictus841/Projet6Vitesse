//
//  Projet6VitesseApp.swift
//  Projet6Vitesse
//
//  Created by Alexandre Talatinian on 29/01/2025.
//

import SwiftUI

@main
struct Projet6VitesseApp: App {
    @StateObject private var appState = AppStateViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if appState.isAuthenticated {
                    CandidatesView(
                        viewModel: CandidatesViewModel(isAdmin: appState.isAdmin),
                        appState: appState
                    )
                } else {
                    LoginView(
                        viewModel: LoginViewModel(appState: appState)
                    )
                }
            }
        }
    }
}

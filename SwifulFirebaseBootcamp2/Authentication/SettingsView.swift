//
//  SettingsView.swift
//  SwifulFirebaseBootcamp2
//
//  Created by Macbook Air on 18-05-24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProvider: [AuthProvider] = []
    
    func loadProviders() {
        if let provider = try? AuthenticationManager.shared.getProviders() {
            authProvider = provider
    }
    }
    
    func signOut() throws{
            try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.badServerResponse)
        }
        
        try await AuthenticationManager.shared.resetPassword( email: email)
    }
    
    func updatePassword(newPassword: String) async throws {
        try await AuthenticationManager.shared.updatePassword(newPassword: newPassword)
    }
    
    func updateEmail(newEmail: String) async throws {
        try await AuthenticationManager.shared.updateEmail(newEmail: newEmail)
    }
}

struct SettingsView: View {

    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            if viewModel.authProvider.contains(.email) {
                emailSection
            }
          
        }
        .onAppear {
            viewModel.loadProviders()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack{
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    private var emailSection: some View {
        Section(header: Text("Email Functions")) {
             Button("Reset Password") {
                 Task {
                     do {
                         try await viewModel.resetPassword()
                     } catch {
                         print(error.localizedDescription)
                     }
                 }
             }
             
             Button("Update Password") {
                 Task {
                     do {
                         try await viewModel.updatePassword(newPassword: "newPassword")
                     } catch {
                         print(error.localizedDescription)
                     }
                 }
             }
             
             Button("Update Email") {
                 Task {
                     do {
                         try await viewModel.updateEmail(newEmail: "newEmail")
                     } catch {
                         print(error.localizedDescription)
                     }
                 }
             }
         }
    }
}

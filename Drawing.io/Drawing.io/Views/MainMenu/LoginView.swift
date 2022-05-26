//
//  LoginView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 30.03.22.
//

import SwiftUI

extension UserDefaults {
    @objc var userId: String? {
        string(forKey: "userId")
    }
}

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: ViewModel
    @State private var userName: String = ""
    @State private var invalidInput = false
    private let userPrefs = UserPreferencesKeys()

    var body: some View {
        VStack {
            TextField(
                "Benutzername",
                text: $userName
            )
            .border(.secondary)
            .padding()
            Button("Fertig"){
                if userName.count > 0 {
                    UserDefaults.standard.set(userName, forKey: userPrefs.username)
                    viewModel.generateUserId(userName)
                    
                } else {
                    invalidInput.toggle()
                }
            }
        }
        .alert(isPresented: $invalidInput) {
            Alert(
                title: Text("Bitte Benutzernamen eingeben!"),
                dismissButton: .default(Text("Nochmal versuchen"))
            )
        }
        .alert(isPresented: $viewModel.showNoConnectionAlert) {
            Alert(
                title: Text("Keine Verbindung zum Server möglich!"),
                dismissButton: .default(Text("Ok"))
            )
        }
        .onReceive(UserDefaults.standard.publisher(for: \.userId)) { id in
            guard id != nil else { return }
            presentationMode.wrappedValue.dismiss()
           
        }
    }
}

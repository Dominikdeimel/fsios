//
//  LoginView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 30.03.22.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var userName: String = ""
    @State private var invalidInput = false

    var body: some View {
        TextField(
            "Benutzername",
            text: $userName
        )
        .border(.secondary)
        .padding()
        Button("Fertig"){
            if userName.count > 0 {
                UserDefaults.standard.set(randomString(), forKey: "userId")
                UserDefaults.standard.set(userName, forKey: "userName")
                presentationMode.wrappedValue.dismiss()
            } else {
                invalidInput.toggle()
            }
        }.alert(isPresented: $invalidInput) {
            Alert(
                title: Text("Bitte Benutzernamen eingeben!"),
                dismissButton: .default(Text("Nochmal versuchen"))
            )
        }
    }

}

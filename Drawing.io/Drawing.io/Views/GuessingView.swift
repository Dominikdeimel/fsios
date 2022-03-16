//
//  GuessingView.swift
//  Drawing.io
//
//  Created by Anja on 08.03.22.
//

import SwiftUI

struct GuessingView: View {
    @State private var word: String = ""
    @State var notMatchedAlert = false
    @State var showScore = false
    @FocusState private var fieldIsFocused: Bool
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Get Image") {
                    viewModel.loadImage()
                }
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .border(.gray)
                TextField(
                    "Wort",
                    text: $word
                )
                    .focused($fieldIsFocused)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .border(.secondary)
                NavigationLink(destination:  ScoreView(), isActive: $showScore) {
                    Text("")
                }
                Button("Submit") {
                    if (viewModel.matchWords(word)) {
                        showScore = true
                    } else {
                        notMatchedAlert = true
                        word = ""
                    }
                }
                .alert(isPresented: $notMatchedAlert) {
                    Alert(
                        title: Text("Falsches Wort"),
                        message: Text("rip du noob"),
                        dismissButton: .default(Text("Nochmal versuchen"))
                    )
                }
            }
            .padding()
        }.navigationTitle("").navigationBarTitleDisplayMode(.inline)
    }
}

struct GuessingView_Previews: PreviewProvider {
    static var previews: some View {
        GuessingView()
    }
}

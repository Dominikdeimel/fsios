//
//  GuessingView.swift
//  Drawing.io
//
//  Created by Anja on 08.03.22.
//

import SwiftUI

struct GuessingView: View {
    @State private var word: String = ""
    @FocusState private var fieldIsFocused: Bool
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
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
                    .onSubmit {
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.secondary)
        }
        .padding()
    }
}

struct GuessingView_Previews: PreviewProvider {
    static var previews: some View {
        GuessingView()
    }
}

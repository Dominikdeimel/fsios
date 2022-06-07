//
//  GuessingView.swift
//  Drawing.io
//
//  Created by Anja on 08.03.22.
//

import SwiftUI

struct GuessingView: View {
    
    @Binding var gameId: String?
    @Binding var showView: Int
    
    @State private var word: String = ""
    @State var notMatchedAlert = false
    
    @FocusState private var fieldIsFocused: Bool
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            TextField(
                "Wort",
                text: $word
            )
                .focused($fieldIsFocused)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .underlineTextField()
            CoolButton(buttonText: "Raten")
                .onTapGesture {
                    if (viewModel.matchWords(word, viewModel.given)) {
                        
                        showView = 3
                    } else {
                        if(viewModel.roundScore > 1){
                            viewModel.roundScore -= 1
                        }
                        notMatchedAlert = true
                    }
                }
                .alert(isPresented: $notMatchedAlert) {
                    Alert(
                        title: Text("Falsches Wort"),
                        dismissButton: .default(Text("Nochmal versuchen"))
                    )
                }
        } .padding()
            .onAppear {
                viewModel.loadGame(gameId)
                viewModel.roundScore = 5
            }
    }
}


//struct GuessingView_Previews: PreviewProvider {
//    static var previews: some View {
//        GuessingView(gameId: nil)
//    }
//}

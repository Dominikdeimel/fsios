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
    @State var roundScore = 5
    @State var counter: Int = 1
    var gameId: String? = nil
    
    @FocusState private var fieldIsFocused: Bool
    @EnvironmentObject var viewModel: ViewModel 
    
    var body: some View {
        if(!showScore){
            VStack {
                ZStack {
                    Rectangle()
                        .fill()
                        .foregroundColor(Color("Main"))
                        .frame(width: 410, height: 410)
                    Rectangle()
                        .strokeBorder(lineWidth: 4)
                        .foregroundColor(Color("Outline"))
                        .frame(width: 410, height: 410)
                        .offset(x: -6.0, y: 8.0)
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                }
                .padding(.vertical)
                TextField(
                    "Wort",
                    text: $word
                )
                .focused($fieldIsFocused)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
                Button("Raten") {
                    if (viewModel.matchWords(word, viewModel.given)) {
                        showScore = true
                    } else {
                        if(roundScore > 1){
                            roundScore -= 1
                        }
                        notMatchedAlert = true
                        word = ""
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
                }
        } else {
            ZStack {
                VStack {
                    Text(viewModel.given)
                        .font(.title2)
                    ZStack {
                        Rectangle()
                            .fill()
                            .foregroundColor(Color("Main"))
                            .frame(width: 410, height: 410)
                        Rectangle()
                            .strokeBorder(lineWidth: 4)
                            .foregroundColor(Color("Outline"))
                            .frame(width: 410, height: 410)
                            .offset(x: -6.0, y: 8.0)
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                    }
                    Text("Punkte: " + String(self.roundScore))
                    Text("Gesamt: " + viewModel.score)
                    ConfettiCannon(counter: $counter)
                }
                .padding()
                .onTapGesture {
                    counter += 1
                }
                ConfettiCannon(counter: $counter)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    counter += 1
                }
                
                viewModel.finishRound(self.roundScore)
            }
        }
    }
    
}


struct GuessingView_Previews: PreviewProvider {
    static var previews: some View {
        GuessingView(gameId: nil)
    }
}

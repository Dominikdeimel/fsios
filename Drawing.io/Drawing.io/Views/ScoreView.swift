//
//  ScoreView.swift
//  Drawing.io
//
//  Created by Anja on 28.05.22.
//

import SwiftUI

struct ScoreView: View {
    
    @Binding var gameId: String?
    @Binding var showView: Int
    @Binding var roundScore: Int
    
    @State var counter: Int = 1
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(viewModel.given.uppercased()).foregroundColor(.green).font(.title2).bold()
                    Text("ist richtig!").bold()
                }
                .padding(.top)
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .bottom, .trailing])
                HStack {
                    VStack {
                        Text("Punkte")
                        Text(String(self.roundScore)).bold()
                    }
                    .padding(.trailing)
                    Divider().padding().frame(height: 100.0)
                    VStack {
                        Text("Gesamt")
                        Text(viewModel.score).bold()
                    }
                    .padding(.leading)
                }
                ConfettiCannon(counter: $counter)
                CoolButton(buttonText: "Weiterzeichnen")
                    .padding(.top)
                    .onTapGesture {
                        showView = 1
                        gameId = viewModel.currentGame?.gameId
                    }
                    .padding()
                    .onTapGesture {
                        counter += 1
                    }
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

//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView(roundScore: 5)
//    }
//}

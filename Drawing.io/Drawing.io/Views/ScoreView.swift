//
//  ScoreView.swift
//  Drawing.io
//
//  Created by Anja on 28.05.22.
//

import SwiftUI

struct ScoreView: View {
    
    @Binding var gameId: String?
    @Binding var state: Int
    @Binding var roundScore: Int
    
    @State var counter: Int = 1
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.given)
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .border(.gray)
                Text("Score: " + String(self.roundScore))
                Text("Gesamtscore: " + viewModel.score)
                ConfettiCannon(counter: $counter)
                CoolButton(buttonText: "Draw").onTapGesture {
                    state = 1
                    gameId = viewModel.currentGame?.gameId 
                }
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

//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView(roundScore: 5)
//    }
//}

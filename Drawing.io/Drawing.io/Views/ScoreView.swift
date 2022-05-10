//
//  ScoreView.swift
//  Drawing.io
//
//  Created by Anja on 16.03.22.
//

import SwiftUI

struct ScoreView: View {
    let roundScore: Int
    
    @EnvironmentObject var viewModel: ViewModel
    @State var counter: Int = 1
    
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
            }
            .padding()
            .onTapGesture {
                counter += 1
                //viewModel.changeScore()
            }
            ConfettiCannon(counter: $counter)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                counter += 1
            }
            //viewModel.finishRound(self.roundScore)
        }
    }
}

//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView()
//    }
//}

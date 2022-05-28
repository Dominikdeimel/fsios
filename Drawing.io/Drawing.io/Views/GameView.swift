//
//  GameView.swift
//  Drawing.io
//
//  Created by Anja on 28.05.22.
//

import SwiftUI

struct GameView: View {
    @State var gameId: String?
    @State var state: Int
    @State var roundScore: Int = 5

    var body: some View {
        if(state == 1) {
            DrawingView(gameId: gameId)
        } else if(state == 2){
            GuessingView(gameId: $gameId, state: $state, roundScore: $roundScore)
        } else if(state == 3){
            ScoreView(gameId: $gameId, state: $state, roundScore: $roundScore)
        } else {
            EmptyView()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameId: nil, state: 0, roundScore: 0)
    }
}

//
//  GameView.swift
//  Drawing.io
//
//  Created by Anja on 28.05.22.
//

import SwiftUI

struct GameView: View {
    @State var gameId: String?
    @State var showView: Int = 0
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        switch showView {
        case 0:
            LoadGameView(gameId: $gameId, showView: $showView)
        case 1:
            DrawingView(gameId: $gameId, showView: $showView)
        case 2:
            GuessingView(gameId: $gameId, showView: $showView)
        case 3:
            ScoreView(gameId: $gameId, showView: $showView)
        default:
            EmptyView()
        }
    }
}

//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView(gameId: nil, showView: 0, roundScore: 0)
//    }
//}

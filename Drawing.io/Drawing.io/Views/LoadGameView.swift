//
//  LoadGameView.swift
//  Drawing.io
//
//  Created by Anja on 11.05.22.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct LoadGameView: View {
    @EnvironmentObject var viewModel: ViewModel
    private let errorMessages = ErrorMessages()

        
    var body: some View {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? errorMessages.missingUserId
        
        return List(viewModel.games, id: \.gameId) { game in
            if(userId == game.activeUser){
                if(game.state == 1){
                    NavigationLink(destination: GameView(gameId: game.gameId, state: game.state)) {
                        content(userId: userId, game: game)
                    }
                } else if(game.state == 2){
                    NavigationLink(destination: NavigationLazyView(GameView(gameId: game.gameId, state: game.state))) {
                        content(userId: userId, game: game)
                    }
                }
            } else {
                content(userId: userId, game: game)
            }
        }.onAppear {
            viewModel.getAllGamesByUserId()
        }
        .refreshable {
            viewModel.getAllGamesByUserId()
        }
    }
            
        
    func content(userId: String, game: Game) -> some View {
        let otherPlayer: String
        if(userId == game.userId_0) {
            otherPlayer = game.userName_1
        } else {
            otherPlayer = game.userName_0
        }
        
        return VStack (alignment: .leading) {
            Text("\(otherPlayer) (Runde \(game.rounds))").font(.headline)
            if(userId == game.activeUser) {
                Text("Du bist dran!").font(.caption).foregroundColor(.red)
            }
            else if(game.state == 1) {
                Text("\(otherPlayer) zeichnet gerade!").font(.caption)
            }
            else if(game.state == 2) {
                Text("\(otherPlayer) rät gerade!").font(.caption)
            } else {
                Text("Warten auf Mitspieler...").font(.caption)
            }
        }
    }
    
}

struct LoadGameView_Previews: PreviewProvider {
    static var previews: some View {
        LoadGameView()
    }
}

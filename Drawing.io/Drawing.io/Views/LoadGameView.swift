//
//  LoadGameView.swift
//  Drawing.io
//
//  Created by Anja on 11.05.22.
//

import SwiftUI

struct LoadGameView: View {
    
    @EnvironmentObject var viewModel: ViewModel

    private var games = [
        Game(gameId: "123", userId_0: "123", userName_0: "anja", userId_1: "234", userName_1: "dominik", activeUser: "123", state: 2, rounds: 5, score: 10, word: "Haus", image: "none"),
        Game(gameId: "1345", userId_0: "123", userName_0: "anja", userId_1: "234", userName_1: "alex", activeUser: "123", state: 1, rounds: 4, score: 10, word: "Haus", image: "none"),
        Game(gameId: "432", userId_0: "123", userName_0: "anja", userId_1: "234", userName_1: "sandy", activeUser: "123", state: 2, rounds: 6, score: 10, word: "Haus", image: "none"),
    ]
    
    var body: some View {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId!"
        return List(games) { game in
            content(userId: userId, game: game)
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
            else {
                Text("\(otherPlayer) rät gerade!").font(.caption)
            }
        }
    }
}

struct LoadGameView_Previews: PreviewProvider {
    static var previews: some View {
        LoadGameView()
    }
}

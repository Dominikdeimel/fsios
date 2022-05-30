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
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    @Binding var gameId: String?
    @Binding var showView: Int
    
    @EnvironmentObject var viewModel: ViewModel
    private let errorMessages = ErrorMessages()
    
    var body: some View {
        HStack {
        if(!viewModel.games.isEmpty) {
            List(viewModel.games, id: \.gameId) { game in
                HStack {
                    content(userId: userId, game: game)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if(userId == game.activeUser) {
                        showView = game.state
                        gameId = game.gameId
                    }
                }
            }
    } else {
            Text("Aktuell keine laufenden Spiele")
                .font(.headline)
        }
    }.refreshable {
        viewModel.getAllGamesByUserId()
    }.onAppear {
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
        
        return HStack {
            if(userId == game.activeUser) {
                Image(systemName: "exclamationmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                    .foregroundColor(.green)
            } else if(game.state == 1) {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                    .foregroundColor(.yellow)
            } else if (game.state == 2) {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                    .foregroundColor(.yellow)
            }
            
            VStack (alignment: .leading) {
                HStack {
                    if(otherPlayer != "") {
                        Text(otherPlayer)
                            .bold()
                            .textCase(.uppercase)
                    }
                    Text("(Runde \(game.rounds))")
                        .font(Font.headline.weight(.light))
                }
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
    
}

//struct LoadGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadGameView(gameId: nil, showView: 0)
//    }
//}

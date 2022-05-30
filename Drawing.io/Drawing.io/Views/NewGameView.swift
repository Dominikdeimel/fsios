//
//  MenuView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 08.03.22.
//

import SwiftUI
import CoreData

struct NewGameView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) var context
    @State private var noGame = false
    @State private var gameExists = false
        
    var body: some View {
            VStack {
                Spacer()
                NavigationLink(destination: GameView(gameId: nil, showView: 1)) {
                    CoolButton(buttonText: "Zeichnen")
                }
                Spacer()
                NavigationLink(destination: GameView(gameId: nil, showView: 2), isActive: $gameExists) {
                    CoolButton(buttonText: "Raten").onTapGesture {
                        viewModel.loadGame(nil)
                        if(viewModel.gameExists) {
                            gameExists = true
                        } else {
                            noGame = true
                        }
                    }
                }
                .alert(isPresented: $noGame) {
                    Alert(
                        title: Text("Kein Spiel verfügbar"),
                        message: Text("Aktuell kannst du kein Spiel mit Erraten beginnen, da keine offenen Spiele existieren. Versuche, mit Zeichnen zu beginnen.")
                        )
                }
                Spacer()
            }
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        FailedRequestsView()
    }
}

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
        
    var body: some View {
            VStack {
                Spacer()
                NavigationLink(destination: DrawingView(gameId: nil)) {
                    CoolButton(buttonText: "Zeichnen")

                }
                Spacer()
                NavigationLink(destination: GuessingView(gameId: nil)) {
                    CoolButton(buttonText: "Raten")
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

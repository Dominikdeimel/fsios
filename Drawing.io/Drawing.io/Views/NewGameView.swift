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
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.cyan)
                            .frame(width: 250, height: 100)
                        Text("Draw").foregroundColor(.black)
                    }
                }
                Spacer()
                NavigationLink(destination: GuessingView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.cyan)
                            .frame(width: 250, height: 100)
                        Text("Guess").foregroundColor(.black)
                    }
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

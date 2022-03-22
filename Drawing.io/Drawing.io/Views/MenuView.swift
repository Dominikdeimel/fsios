//
//  MenuView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 08.03.22.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var userData: FetchedResults<FailedImagePost>

    @State private var showLoginScreen = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: ContentView()) {
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
            }.navigationTitle("Drawing.io").navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    let userName = UserDefaults.standard.string(forKey: "userName")
                    if(userName == nil) {
                        showLoginScreen.toggle()
                    }
                }.sheet(isPresented: $showLoginScreen) {
                    LoginView()
                }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

//
//  MenuView.swift
//  Drawing.io
//
//  Created by Anja on 11.05.22.
//

import SwiftUI

struct MenuView: View {
    @FetchRequest(sortDescriptors: []) var failedImagePosts: FetchedResults<FailedRequest>
    
    @State var showFailedRequests = false
    @State var showLoginScreen = false
    private let userPrefs = UserPreferencesKeys()


    var body: some View {
        NavigationView {
            VStack {
                if(!failedImagePosts.isEmpty){
                    HStack{
                        Spacer()
                        Button(action: {
                            showFailedRequests.toggle()
                        }, label: {
                            Image(systemName: "exclamationmark.icloud")
                        }).padding(.trailing)
                            .sheet(isPresented: $showFailedRequests) {
                                FailedRequestsView()
                            }
                    }
                }
                Image("Logo").padding(.bottom).scaleEffect(0.2).frame(width: 50.0, height: 250.0)
                Spacer()
                NavigationLink(destination: NewGameView()) {
                    CoolButton(buttonText: "Neues Spiel")
                }
                .padding(.vertical)
                NavigationLink(destination: GameView(gameId: nil, showView: 0, roundScore: 0)) {
                    CoolButton(buttonText: "Spiel laden")
                }
                .padding(.top)
                Spacer()
            }.navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    UIApplication.shared.registerForRemoteNotifications()
                    let userId = UserDefaults.standard.string(forKey: "userId")
                    if(userId == nil) {
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

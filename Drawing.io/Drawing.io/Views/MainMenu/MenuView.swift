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
                    CoolButton(buttonText: "New Game")
                }
                .padding(.vertical)
                NavigationLink(destination: LoadGameView()) {
                    CoolButton(buttonText: "Load Game")
                }
                .padding(.top)
                Spacer()
            }.navigationTitle("Drawing.io")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    let userName = UserDefaults.standard.string(forKey: "userId")
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

//
//  MenuView.swift
//  Drawing.io
//
//  Created by Anja on 11.05.22.
//

import SwiftUI

struct MenuView: View {
    @FetchRequest(sortDescriptors: []) var failedImagePosts: FetchedResults<FailedImagePost>
    
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
                Spacer()
                NavigationLink(destination: LoadGameView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.cyan)
                            .frame(width: 250, height: 100)
                        Text("Load Game").foregroundColor(.black)
                    }
                }
                Spacer()
                NavigationLink(destination: NewGameView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.cyan)
                            .frame(width: 250, height: 100)
                        Text("New Game").foregroundColor(.black)
                    }
                }
                Spacer()
            }.navigationTitle("Drawing.io")
                .navigationBarTitleDisplayMode(.inline)
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

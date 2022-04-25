//
//  MenuView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 08.03.22.
//

import SwiftUI
import CoreData

struct MenuView: View {
    @FetchRequest(sortDescriptors: []) var failedImagePosts: FetchedResults<FailedImagePost>
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) var context
    
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
                NavigationLink(destination: DrawingView()) {
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
        FailedRequestsView()
    }
}

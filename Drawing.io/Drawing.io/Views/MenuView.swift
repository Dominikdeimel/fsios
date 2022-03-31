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

struct FailedRequestsView: View {
    @FetchRequest(sortDescriptors: []) var failedImagePosts: FetchedResults<FailedImagePost>
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Fehlerhafte Bildübertragungen").font(.title)
            Spacer()
            List(failedImagePosts){ failedImagePost in
                FailedRequestsRow(failedImagePost: failedImagePost)
            }
        }
    }
}

struct FailedRequestsRow: View {
    @EnvironmentObject var viewModel: ViewModel
    var failedImagePost: FailedImagePost
    
    var body: some View {
        HStack {
            Text("Fehlerhafte Übertragung von " + (failedImagePost.errorDate?.formatted() ?? "No Date available"))
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.retryPostData(failedImagePost)
                }
            }, label: {
                Image(systemName: "icloud.and.arrow.up")
            })
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        FailedRequestsView()
    }
}

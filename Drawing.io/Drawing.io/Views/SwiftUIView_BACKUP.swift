//
//  SwiftUIView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 17.03.22.
//

import SwiftUI
import CoreData

struct SwiftUIView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var failedImagePosts: FetchedResults<FailedImagePost>
    var viewModel : ViewModel
    
    var body: some View {
        VStack {
            Button("Add") {
                //viewModel.createFailedImagePost(UIImage(), context)
            }
            List(failedImagePosts){
                Text($0.gameId ?? "bug")
            }
        }
    }
}

func randomString() -> String {
    let chars = "abcdefghijklmnopqrstuvwxyz1234567890"
    var randomString = ""
    for _ in 0...10 {
        randomString += chars.randomElement()!.description
    }
    
    return randomString
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        SwiftUIView(viewModel: viewModel)
    }
}

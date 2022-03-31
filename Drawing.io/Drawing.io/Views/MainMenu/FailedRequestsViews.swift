//
//  FailedRequestsViews.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 31.03.22.
//

import SwiftUI


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

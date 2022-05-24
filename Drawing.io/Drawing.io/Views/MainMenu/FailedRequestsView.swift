//
//  FailedRequestsViews.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 31.03.22.
//

import SwiftUI


struct FailedRequestsView: View {
    @FetchRequest(sortDescriptors: []) var failedRequests: FetchedResults<FailedRequest>
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Fehlerhafte Bildübertragungen").font(.title)
            Spacer()
            List(failedRequests){ failedRequest in
                FailedRequestsRow(failedRequest: failedRequest)
            }
        }
    }
}

struct FailedRequestsRow: View {
    @EnvironmentObject var viewModel: ViewModel
    var failedRequest: FailedRequest
    
    
    var body: some View {
        HStack {
            Text("Fehlerhafte Übertragung von " + (failedRequest.errorDate?.formatted() ?? "No Date available"))
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.retryFailedRequest(failedRequest)
                }
            }, label: {
                Image(systemName: "icloud.and.arrow.up")
            })
        }.foregroundColor((failedRequest.type == "initialPostData") ? .red : .blue)
    }
}

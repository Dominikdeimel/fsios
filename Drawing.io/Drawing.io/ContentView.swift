//
//  ContentView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        Text(viewModel.text)
            .padding()
        Button("Get Data"){
            viewModel.loadImage()
            
        }
        Button("Post Data"){
            viewModel.postData()
        }
        Image(uiImage: viewModel.image)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        ContentView(viewModel: viewModel)
    }
}

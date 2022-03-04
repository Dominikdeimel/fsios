//
//  Drawing_ioApp.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI

@main
struct Drawing_ioApp: App {
    var body: some Scene {
        let viewModel = ViewModel()
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}

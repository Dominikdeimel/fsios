//
//  Drawing_ioApp.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI

@main
struct Drawing_ioApp: App {
    @StateObject private var databaseController = DatabaseController()
    @StateObject var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            MenuView()
            .environment(\.managedObjectContext, databaseController.container.viewContext)
            .environmentObject(viewModel)
        }
    }
}

//
//  Drawing_ioApp.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI

@main
struct Drawing_ioApp: App {
    @StateObject private var databaseController: DatabaseController
    @StateObject private var viewModel: ViewModel
    
    init() {
        let db = DatabaseController()
        self._databaseController = StateObject(wrappedValue: db)
        self._viewModel = StateObject(wrappedValue: ViewModel(context: db.container.viewContext))
    }
    
    var body: some Scene {
        WindowGroup {   
            MenuView()
                .environment(\.managedObjectContext, databaseController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}

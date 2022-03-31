//
//  DataController.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 18.03.22.
//

import Foundation
import CoreData

class DatabaseController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
            }
        }
        print(try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
    }
}

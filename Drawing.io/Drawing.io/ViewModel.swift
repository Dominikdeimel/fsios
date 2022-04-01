//
//  ViewModel.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class ViewModel: ObservableObject {
    private var networkModel = NetworkModel()
    private var databaseModel = DatabaseModel()
    
    private var getCancellable: AnyCancellable?
    private var postCancellable: AnyCancellable?
    @Published var image = UIImage()
    @Published var given: String = "Haus"
    @Environment(\.managedObjectContext) var context
    
    func loadImage() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getImage().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { data in            
            let imageData = Data(base64Encoded: data.imageAsBase64)
            if let imageData = imageData {
                self.image = UIImage(data: imageData)!
            }
            let wordData = data.word
            self.given = wordData
        })
    }
    
    func loadWord() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getRandomWord().sink(receiveValue: { word in
            self.given = word ?? "Haus"
        })
    }
    
    func postData(_ image: UIImage) {
        self.postCancellable?.cancel()
        self.postCancellable =  networkModel.postInput(image, given).sink(receiveCompletion: {
            err in print(err)
            self.databaseModel.createFailedImagePost(image, self.context)
        }, receiveValue: {code in
            if code != 200 {
                self.databaseModel.createFailedImagePost(image, self.context)
                print("Error beim posten")
            }
        })
    }
    
    func matchWords(_ guessed: String, _ wordData: String) -> Bool {
        if wordData.lowercased() == guessed.lowercased() {
            return true
        } else {
            return false
        }
    }
    
    deinit {
        self.getCancellable?.cancel()
        self.postCancellable?.cancel()
    }
}

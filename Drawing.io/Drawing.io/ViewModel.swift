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
    @Published var given = "Haus"
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadImage() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getImage().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { data in            
            let imageData = Data(base64Encoded: data.imageAsBase64)
            if let imageData = imageData {
                self.image = UIImage(data: imageData)!
            }
        })
    }
    
    
    func postData(_ image: UIImage) {
        self.postCancellable?.cancel()
        self.postCancellable =  networkModel.postImage(image).sink(receiveCompletion: {
            err in
            switch err {
            case .finished:
                break
            case .failure(_):
                self.databaseModel.createFailedImagePost(image, self.context)
            }
        }, receiveValue: {code in
            if code != 200 {
                self.databaseModel.createFailedImagePost(image, self.context)
                print("Error while posting")
            }
        })
    }
    
    func retryPostData(_ failedImagePost: FailedImagePost){
        self.postCancellable?.cancel()
        let imageAsBase64 = failedImagePost.imageAsBase64 ?? "Missing image data"
        let gameId = failedImagePost.gameId ?? "Missing gameId"
        
        self.postCancellable = networkModel.retryPostImage(imageAsBase64, gameId).sink(receiveCompletion: { _ in
        }, receiveValue: {statuscode in
            if statuscode == 200 {
                self.databaseModel.deleteFailedImagePost(failedImagePost, self.context)
            }
        })
    }
    
    func matchWords(_ guessed: String) -> Bool {
        if given.lowercased() == guessed.lowercased() {
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

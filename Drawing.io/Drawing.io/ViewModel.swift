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
    private let constants = Constants()
    private let errorMessages = ErrorMessages()
    
    private var getCancellable: AnyCancellable?
    private var postCancellable: AnyCancellable?
    private var currentGame: Game?
    
    @Published var image = UIImage()
    @Published var given = ""
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadNewGame() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getNewGame().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { game in
            let imageData = Data(base64Encoded: game.image)
            if let imageData = imageData {
                self.image = UIImage(data: imageData)!
            }
            self.currentGame = game
            self.given = game.word
        })
    }
    
    func loadWord() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getRandomWord().sink(receiveValue: { word in
            self.given = word ?? self.constants.defaultGiven
        })
    }
    
    func postData(_ image: UIImage, _ gameId: String = "") {
        self.postCancellable?.cancel()
        self.postCancellable =  networkModel.postInput(image, given).sink(receiveCompletion: {
            err in
            switch err {
            case .finished:
                break
            case .failure(_):
                self.databaseModel.createFailedImagePost(image, gameId, self.context)
            }
        }, receiveValue: {code in
            if code != 200 {
                self.databaseModel.createFailedImagePost(image, gameId, self.context)
                print(self.errorMessages.postingError)
            }
        })
    }
    
    func retryPostData(_ failedImagePost: FailedImagePost){
        self.postCancellable?.cancel()
        let imageAsBase64 = failedImagePost.imageAsBase64 ?? errorMessages.missingImageData
        let gameId = failedImagePost.gameId ?? errorMessages.missingGameId
        
        self.postCancellable = networkModel.retryPostImage(imageAsBase64, gameId, given).sink(receiveCompletion: { _ in
        }, receiveValue: {statuscode in
            if statuscode == 200 {
                self.databaseModel.deleteFailedImagePost(failedImagePost, self.context)
            }
        })
    }
    
    func generateUserId(_ name: String){
        self.postCancellable?.cancel()
        self.postCancellable = networkModel.generateUserId(name).sink(receiveValue: { id in
            UserDefaults.standard.set(id, forKey: "userId")
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
    
    struct Constants {
        let emptyString = ""
        let defaultGiven = "Haus"
    }
    
    struct ErrorMessages {
        let postingError = "Error while posting"
        let missingImageData = "Missing imagedata"
        let missingGameId = "Missing gameId"
    }
}

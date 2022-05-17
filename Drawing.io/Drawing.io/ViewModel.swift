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
    private var currentGame: Game?
    
    @Published var image = UIImage()
    @Published var given = ""
    @Published var score = ""
    @Published var games = Array<Game>()
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadGame(_ gameId: String?) {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getGame(gameId).sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { game in
            let imageData = Data(base64Encoded: game.image)
            if let imageData = imageData, let image = UIImage(data: imageData) {
                self.image = image
            }
            self.currentGame = game
            self.given = game.word
        })
    }
    
    func getAllGamesByUserId() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getAllGamesByUserId().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { games in
            self.games = games
        })
    }
    
    func loadWord() {
        self.getCancellable?.cancel()
        self.getCancellable = networkModel.getRandomWord().sink(receiveValue: { word in
            self.given = word ?? "Haus"
        })
    }
    
    func postData(_ image: UIImage, _ gameId: String? = nil) {
        self.postCancellable?.cancel()
        if(gameId == nil){
            self.postCancellable =  networkModel.postInitalData(image, given).sink(receiveCompletion: {
                err in
                switch err {
                case .finished:
                    break
                case .failure(_):
                    self.databaseModel.createFailedImagePost(image, (gameId != nil) ? gameId! : "" , self.context)
                }
            }, receiveValue: {code in
                if code != 200 {
                    //self.databaseModel.createFailedImagePost(image, gameId, self.context)
                    print("Error while posting")
                }
            })
        } else {
            self.postCancellable = networkModel.postData(image, given, (gameId != nil) ? gameId! : "").sink(receiveCompletion: { _ in
            }, receiveValue: {code in
                if code != 200 {
                    //self.databaseModel.createFailedImagePost(image, gameId, self.context)
                    print("Error while posting")
                }
            })
        }
    }
    
    func retryPostData(_ failedImagePost: FailedImagePost){
        self.postCancellable?.cancel()
        let imageAsBase64 = failedImagePost.imageAsBase64 ?? "Missing image data"
        let gameId = failedImagePost.gameId ?? "Missing gameId"
        
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
    
    func finishRound(_ roundScore: Int){
        self.postCancellable?.cancel()
        self.postCancellable = networkModel.postRoundInformation(roundScore: roundScore, gameId: currentGame!.gameId).sink(receiveCompletion: { err in
            print(err)
        }, receiveValue: { totalScore in
            self.score = totalScore
        })
    }
    
    deinit {
        self.getCancellable?.cancel()
        self.postCancellable?.cancel()
    }
}

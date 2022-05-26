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
    private let userPrefs = UserPreferencesKeys()
    private let errorMessages = ErrorMessages()
    
    private var getCancellable: AnyCancellable?
    private var postCancellable: AnyCancellable?
    private var currentGame: Game?
    
    @Published var image = UIImage()
    @Published var given = ""
    @Published var score = ""
    @Published var games = Array<Game>()
    @Published var showNoConnectionAlert = false
    
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
            self.postCancellable =  networkModel.postInitalData(getImageAsBase64(image), given).sink(receiveCompletion: {
                result in
                switch result {
                case .finished:
                    break
                case .failure(_):
                    self.databaseModel.createFailedRequests(requestType: FailedRequestType.initialDataPost, gameId: "", image: image, word: self.given, self.context)
                }
            }, receiveValue: {code in
                if code != 200 {
                    self.databaseModel.createFailedRequests(requestType: FailedRequestType.initialDataPost, gameId: "", image: image, word: self.given, self.context)
                }
            })
        } else {
            self.postCancellable = networkModel.postData(getImageAsBase64(image), given, (gameId != nil) ? gameId! : "").sink(receiveCompletion: {
                result in
                switch result {
                case .finished:
                    break
                case .failure(_):
                    self.databaseModel.createFailedRequests(requestType: FailedRequestType.dataPost, gameId: gameId ?? "", image: image, word: self.given, self.context)
                }
            }, receiveValue: {code in
                if code != 200 {
                    self.databaseModel.createFailedRequests(requestType: FailedRequestType.dataPost, gameId: gameId ?? "", image: image, word: self.given, self.context)
                }
            })
        }
    }
    
    func retryFailedRequest(_ failedRequest: FailedRequest){
        self.postCancellable?.cancel()
        
        switch failedRequest.type {
        case "initialPostData":
            self.postCancellable = networkModel.postInitalData(failedRequest.imageAsBase64!, failedRequest.word!).sink(receiveCompletion: { _ in
            }, receiveValue: {statuscode in
                if(statuscode == 200){
                    self.databaseModel.deleteFailedImagePost(failedRequest, self.context)
                }            })
        case "postData":
            self.postCancellable = networkModel.postData(failedRequest.imageAsBase64!, failedRequest.word!, failedRequest.gameId!).sink(receiveCompletion: { _ in
            }, receiveValue: {statuscode in
                if(statuscode == 200){
                    self.databaseModel.deleteFailedImagePost(failedRequest, self.context)
                }            })
        default: print("Nicht definierter failedRequestType")
        }
        
    }
    
    func generateUserId(_ name: String){
        self.postCancellable?.cancel()
        self.postCancellable = networkModel.generateUserId(name).sink { id in
            if(id != nil){
                UserDefaults.standard.set(id, forKey: "userId")
            } else {
                self.showNoConnectionAlert = true
            }
        }
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

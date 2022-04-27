//
//  Model.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import Foundation
import SwiftUI
import Combine

struct NetworkModel {
    private let routes = Routes()
    private let errorMessages = ErrorMessages()
    
    func getNewGame() -> AnyPublisher<Game, Error> {
        var url = URLComponents(string: routes.getNewGame)!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId"

        url.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        let request = URLRequest(url: url.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map {
                print($0.data)
                return $0.data
            }
            .decode(type: Game.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getRandomWord() -> AnyPublisher<String?, Never> {
        let url = URL(string: routes.getRandomWord)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { String(data: $0.data, encoding: .utf8) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postInput(_ image: UIImage, _ word: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: routes.postImage)!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? errorMessages.missingUserId
        let userName = UserDefaults.standard.string(forKey: "userName") ?? errorMessages.missingUserName
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageAsBase64 = imageData?.base64EncodedString() ?? ""
       
        let userImage = UserImage(userId: userId, gameId: "", userName: userName, imageAsBase64: imageAsBase64, word: word)
        let encodedUserImage = try! JSONEncoder().encode(userImage)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedUserImage
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { let response = $0.response as! HTTPURLResponse
                return response.statusCode
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func retryPostImage(_ imageAsBase64: String, _ gameId: String, _ word: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: routes.postImage)!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? errorMessages.missingUserId
        let userName = UserDefaults.standard.string(forKey: "userName") ?? errorMessages.missingUserName

        let userImage = UserImage(userId: userId, gameId: gameId, userName: userName, imageAsBase64: imageAsBase64, word: word)
        let encodedUserImage = try! JSONEncoder().encode(userImage)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedUserImage
        
        return URLSession.shared.dataTaskPublisher(for: request)
            . map {
                let response = $0.response as! HTTPURLResponse
                return response.statusCode
                }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //func finishRound(roundScore: Int, gameId: String) -> AnyPublisher<Int, URLError> {
        
    //}
    
    
    
    func generateUserId(_ name: String) -> AnyPublisher<String?, Never> {
        let url = URL(string: routes.generateUserId)!
        let usersName = UsersName(name: name)
        var request = URLRequest(url: url)
        
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(usersName)
        

        return URLSession.shared.dataTaskPublisher(for: request)
            . map { String(data: $0.data, encoding: .utf8) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    struct Routes {
        let getNewGame = "http://localhost:3000/game/initial"
        let getRandomWord = "http://localhost:3000/word"
        let postImage = "http://localhost:3000/image"
        let generateUserId = "http://localhost:3000/id"
    }
    
    struct ErrorMessages {
        let missingImageData = "Missing imagedata"
        let missingGameId = "Missing gameId"
        let missingUserName = "Missing userName"
        let missingUserId = "Missing userId"
    }
}

struct UserImage: Codable {
    let userId: String
    let gameId: String
    let userName: String
    let imageAsBase64: String
    let word: String
}

struct UsersName: Codable {
    let name: String
}

struct Game: Codable {
    let gameId: String
    let userId_0: String
    let userId_1: String
    let activeUser: String
    let state: Int
    let rounds: Int
    let score: Int
    let word: String
    let image: String
}

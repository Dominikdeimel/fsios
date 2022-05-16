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
    
    func getGame(_ gameId: String?) -> AnyPublisher<Game, Error> {
        var url = URLComponents(string: "http://localhost:3000/game/guessing")!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId"

        url.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "gameId", value: gameId)
        ]
        
        let request = URLRequest(url: url.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Game.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getAllGamesByUserId() -> AnyPublisher<Array<Game>, Error> {
        var url = URLComponents(string: "http://localhost:3000/game/all")!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId"

        url.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        let request = URLRequest(url: url.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Array<Game>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    
    func getRandomWord() -> AnyPublisher<String?, Never> {
        let url = URL(string: "http://localhost:3000/word")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { String(data: $0.data, encoding: .utf8) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postInitalData(_ image: UIImage, _ word: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: "http://localhost:3000/game/initial/drawing")!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId"
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "Missing userName"
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageAsBase64 = imageData?.base64EncodedString() ?? "Missing image data"
       
        let userImage = InitialUserImage(userId: userId, gameId: "", userName: userName, imageAsBase64: imageAsBase64, word: word)
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
    
    func postData(_ image: UIImage, _ word: String, _ gameId: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: "http://localhost:3000/game/drawing")!
        let imageData = image.jpegData(compressionQuality: 1)
        let imageAsBase64 = imageData?.base64EncodedString() ?? "Missing image data"
       
        let userImage = UserImage(gameId: gameId, imageAsBase64: imageAsBase64, word: word)
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
        let url = URL(string: "http://localhost:3000/game/initial/drawing")!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId!"
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "Missing userName!"

        let userImage = InitialUserImage(userId: userId, gameId: gameId, userName: userName, imageAsBase64: imageAsBase64, word: word)
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
    
    func postRoundInformation(roundScore: Int, gameId: String) -> AnyPublisher<String, URLError> {
        let url = URL(string: "http://localhost:3000/game/finishround")!
        let roundInformation = RoundInformation(gameId: gameId, roundScore: roundScore)
        let encodedRoundInformation = try! JSONEncoder().encode(roundInformation)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedRoundInformation
        
        return URLSession.shared.dataTaskPublisher(for: request)
            . map { String(data: $0.data, encoding: .utf8)! }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func generateUserId(_ name: String) -> AnyPublisher<String?, Never> {
        let url = URL(string: "http://localhost:3000/id")!
        let userName = UserName(name: name)
        var request = URLRequest(url: url)
        
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(userName)
        

        return URLSession.shared.dataTaskPublisher(for: request)
            . map { String(data: $0.data, encoding: .utf8) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

struct RoundInformation : Codable {
    let gameId: String
    let roundScore: Int
}

struct InitialUserImage: Codable {
    let userId: String
    let gameId: String
    let userName: String
    let imageAsBase64: String
    let word: String
}

struct UserImage: Codable {
    let gameId: String
    let imageAsBase64: String
    let word: String
}

struct UserName: Codable {
    let name: String
}

struct Game: Codable {
    let gameId: String
    let userId_0: String
    let userName_0: String
    let userId_1: String
    let userName_1: String
    let activeUser: String
    let state: Int
    let rounds: Int
    let score: Int
    let word: String
    let image: String
}

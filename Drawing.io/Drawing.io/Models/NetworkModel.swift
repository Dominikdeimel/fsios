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
    private let urls = Urls()
    private let errorMessages = ErrorMessages()
    private let userPrefs = UserPreferencesKeys()
    
    func getGame(_ gameId: String?) -> AnyPublisher<Game, Error> {
        var url = URLComponents(string: urls.game_guessing)!
        let userId = UserDefaults.standard.string(forKey: userPrefs.userId) ?? errorMessages.missingUserId

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
        var url = URLComponents(string: urls.game_all)!
        let userId = UserDefaults.standard.string(forKey: userPrefs.userId) ?? errorMessages.missingUserId

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
        let url = URL(string: urls.word)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { String(data: $0.data, encoding: .utf8) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postInitalData(_ imageAsBase64: String, _ word: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: urls.game_initial_drawing)!
        let userId = UserDefaults.standard.string(forKey: userPrefs.userId) ?? errorMessages.missingUserId
        let userName = UserDefaults.standard.string(forKey: userPrefs.username) ?? errorMessages.missingUserName
               
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
    
    func postData(_ imageAsBase64: String, _ word: String, _ gameId: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: urls.game_drawing)!

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
    
    func postRoundInformation(roundScore: Int, gameId: String) -> AnyPublisher<String, URLError> {
        let url = URL(string: urls.finishRound)!
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
        let url = URL(string: urls.id)!
        let deviceToken = UserDefaults.standard.string(forKey: userPrefs.deviceToken) ?? errorMessages.deviceToken
        let userName = UserInfo(name: name, deviceToken: deviceToken)
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
private struct Urls {
    //static let baseUrl = "http://192.168.178.29:3000"
    static let baseUrl = "http://localhost:3000"
    let game_guessing = "\(baseUrl)/game/guessing"
    let game_all = "\(baseUrl)/game/all"
    let word = "\(baseUrl)/word"
    let game_initial_drawing = "\(baseUrl)/game/initial/drawing"
    let game_drawing = "\(baseUrl)/game/drawing"
    let finishRound = "\(baseUrl)/game/finishround"
    let id = "\(baseUrl)/id"
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

struct UserInfo: Codable {
    let name: String
    let deviceToken: String
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

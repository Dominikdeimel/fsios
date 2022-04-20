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
    
    func getImage() -> AnyPublisher<UserImage, Error> {
        let url = URL(string: "http://localhost:3000/image")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UserImage.self, decoder: JSONDecoder())
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
    
    func postInput(_ image: UIImage, _ word: String) -> AnyPublisher<Int, URLError> {
        let url = URL(string: "http://localhost:3000/image")!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId"
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "Missing userName"
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageAsBase64 = imageData?.base64EncodedString() ?? "Missing image data"
       
        let userImage = UserImage(userId: userId, gameId: randomString(), userName: userName, imageAsBase64: imageAsBase64, word: word)
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
        let url = URL(string: "http://localhost:3000/image")!
        let userId = UserDefaults.standard.string(forKey: "userId") ?? "Missing userId!"
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "Missing userName!"

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
    
    
    func generateUserId(_ name: String) -> AnyPublisher<String?, Never> {
        let url = URL(string: "http://localhost:3000/id")!
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

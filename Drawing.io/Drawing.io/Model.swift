//
//  Model.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import Foundation
import SwiftUI
import Combine

struct Model {
    
    func getData() -> AnyPublisher<UserImage, Error> {
        let url = URL(string: "http://localhost:3000/image")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UserImage.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postImage(_ image: UIImage) -> AnyPublisher<Int, URLError> {
        let url = URL(string: "http://localhost:3000/image")!
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageBase64String = imageData?.base64EncodedString()
        
        let userImage = UserImage(userId: randomString(), imageAsBase64: imageBase64String!)
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
    
    func randomString() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz1234567890"
        var randomString = ""
        for _ in 0...10 {
            randomString += chars.randomElement()!.description
        }
        
        return randomString
    }
}

struct UserImage: Codable {
    let userId: String
    let imageAsBase64: String
}

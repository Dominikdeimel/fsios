//
//  Util.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 30.03.22.
//

import Foundation
import UIKit

func randomString() -> String {
    let chars = "abcdefghijklmnopqrstuvwxyz1234567890"
    var randomString = ""
    for _ in 0...10 {
        randomString += chars.randomElement()!.description
    }

    return randomString
}

func getImageAsBase64(_ image: UIImage) -> String {
    let imageData = image.jpegData(compressionQuality: 1)
    return imageData?.base64EncodedString() ?? "Missing image data"
}


struct ErrorMessages {
    let missingUserId = "Missing userId"
    let missingUserName = "Missing userName"
    let missingImageData = "Missing imageData"
    let missingGameId = "Missing gameId"
    let deviceToken = ""
    let posting = "Error while posting"
}

struct UserPreferencesKeys {
    let userId = "userId"
    let username = "userName"
    let deviceToken = "deviceToken"
}

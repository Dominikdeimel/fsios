//
//  Util.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 30.03.22.
//

import Foundation

func randomString() -> String {
    let chars = "abcdefghijklmnopqrstuvwxyz1234567890"
    var randomString = ""
    for _ in 0...10 {
        randomString += chars.randomElement()!.description
    }

    return randomString
}

struct ErrorMessages {
    let missingUserId = "Missing userId"
    let missingUserName = "Missing userName"
    let missingImageData = "Missing imageData"
    let missingGameId = "Missing gameId"
    let posting = "Error while posting"
}

struct UserPreferencesKeys {
    let userId = "userId"
    let username = "userName"
}

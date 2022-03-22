//
//  Util.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 21.03.22.
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

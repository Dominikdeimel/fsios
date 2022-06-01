//
//  DatabaseModel.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 18.03.22.
// 

import Foundation
import UIKit
import CoreData

struct DatabaseModel {
    
    func createFailedRequests(requestType: FailedRequestType, gameId: String, image: UIImage?, word: String, _ context: NSManagedObjectContext) {
        let failedRequest = FailedRequest(context: context)
        failedRequest.errorDate = Date()
        failedRequest.gameId = gameId
        failedRequest.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        failedRequest.type = requestType.rawValue
        failedRequest.imageAsBase64 = (image != nil) ? getImageAsBase64(image ?? UIImage()) : ""
        failedRequest.word = word
        
        try? context.save()
        
    }
    
    func deleteFailedRequest(_ failedRequest: FailedRequest, _ context: NSManagedObjectContext) {
        context.delete(failedRequest)
        try? context.save()
        
    }
}

enum FailedRequestType: String {
    case initialDataPost = "initialPostData"
    case dataPost = "postData"
}

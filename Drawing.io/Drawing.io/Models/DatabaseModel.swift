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
    private let errorMessages = ErrorMessages()

    func createFailedImagePost(_ image: UIImage, _ gameId: String, _ context: NSManagedObjectContext) {
        let imageData = image.jpegData(compressionQuality: 1)
        let imageAsBase64 = imageData?.base64EncodedString() ?? errorMessages.missingImageData
        
        let failedImagePost = FailedImagePost(context: context)
        
        failedImagePost.gameId = gameId
        failedImagePost.imageAsBase64 = imageAsBase64
        failedImagePost.errorDate = Date()
        
        try? context.save()
        
    }
    
    func deleteFailedImagePost(_ failedImagePost: FailedImagePost, _ context: NSManagedObjectContext) {
        context.delete(failedImagePost)
        try? context.save()
       
    }
}

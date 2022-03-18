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
    
    func createFailedImagePost(_ image: UIImage, _ context: NSManagedObjectContext) {
        let imageData = image.jpegData(compressionQuality: 1)
        let imageAsBase64 = imageData?.base64EncodedString() ?? "Missing image data"
        
        let failedImagePost = FailedImagePost(context: context)
        failedImagePost.gameId = randomString()
        failedImagePost.imageAsBase64 = imageAsBase64
        failedImagePost.errorDate = Date()
        
        try? context.save()
    }
}

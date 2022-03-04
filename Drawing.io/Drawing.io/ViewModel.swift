//
//  ViewModel.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    private var model = Model()
    private var getCancellable: AnyCancellable?
    private var postCancellable: AnyCancellable?
    
    
    func loadImage() {
     /*   self.getCancellable?.cancel()
        self.getCancellable = model.getData().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { data in            
            let imageData = Data(base64Encoded: data.imageAsBase64)
            if let imageData = imageData {
                self.image = UIImage(data: imageData)!
            }
            
        })*/
    }
    func postData(_ image: UIImage) {
        self.postCancellable?.cancel()
        self.postCancellable =  model.postImage(image).sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: {_ in
            //TODO: Error Handling
        })
    }
    
    deinit {
        self.getCancellable?.cancel()
        self.postCancellable?.cancel()
    }
}

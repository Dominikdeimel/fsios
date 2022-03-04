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
    @Published private(set) var text = ":/"
    @Published private(set) var image = UIImage()
    
    private var getCancellable: AnyCancellable?
    private var postCancellable: AnyCancellable?
    
    
    func loadImage() {
        self.getCancellable?.cancel()
        self.getCancellable = model.getData().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: { data in
            self.text = data.userId
            
            let imageData = Data(base64Encoded: data.imageAsBase64)
            if let imageData = imageData {
                self.image = UIImage(data: imageData)!
            }
            
        })
    }
    func postData() {
        self.postCancellable?.cancel()
        self.postCancellable =  model.postImage().sink(receiveCompletion: {
            err in print(err)
        }, receiveValue: {code in
            self.text = "Post scheint funktioniert zu haben mit Code \(code)"
        })
    }
    
    deinit {
        self.getCancellable?.cancel()
        self.postCancellable?.cancel()
    }
}

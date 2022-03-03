//
//  Canvas.swift
//  Drawing.io
//
//  Created by Anja on 02.03.22.
//

import SwiftUI

struct Canvas: UIViewControllerRepresentable {
    var dataModelController = DataModelController()
    var vc: DrawingViewController
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        vc.dataModelController = dataModelController
        dataModelController.newDrawing()
        vc.drawingIndex = 0
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        
    }
}

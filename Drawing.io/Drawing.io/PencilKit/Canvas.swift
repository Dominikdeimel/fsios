//
//  Canvas.swift
//  Drawing.io
//
//  Created by Anja on 02.03.22.
//

import SwiftUI

struct Canvas: UIViewControllerRepresentable {
    var vc: DrawingViewController
    
    func makeUIViewController(context: Context) -> DrawingViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        
    }
}

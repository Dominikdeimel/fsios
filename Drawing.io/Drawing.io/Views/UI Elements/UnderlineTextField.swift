//
//  UnderlineTextField.swift
//  Drawing.io
//
//  Created by Anja on 28.05.22.
//

import SwiftUI

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(Color("Outline"))
            .padding(10)
    }
}

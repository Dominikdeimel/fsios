//
//  CoolButton.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 17.05.22.
//

import SwiftUI

struct CoolButton: View {
    let buttonText: String
    var body: some View {
        ZStack {
            Capsule()
                .fill()
                .foregroundColor(Color("Main"))
                .frame(width: 320, height: 45)
                .offset(x: 6.0, y: -8.0)
            Capsule()
                .strokeBorder(lineWidth: 4)
                .foregroundColor(Color("Outline"))
                .frame(width: 330, height: 50)
            Text(buttonText).foregroundColor(Color("Outline")).bold()
        }
    }
}

struct CoolButton_Previews: PreviewProvider {
    static var previews: some View {
        CoolButton(buttonText: "Hello World")
    }
}

//
//  ContentView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @Environment(\.undoManager) private var undoManager
    private var drawingController = DrawingViewController()
    
    var body: some View {
        VStack {
            HStack {
                Text("Wort")
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "checkmark")
                })
                    .padding(.horizontal)
            }
            .padding(.vertical)
            HStack {
                Button(action: {
                    drawingController.clear()
                }, label: {
                    Image(systemName: "trash")
                })
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    undoManager?.undo()
                }, label: {
                    Image(systemName: "arrow.uturn.backward")
                })
                Button(action: {
                    undoManager?.redo()
                }, label: {
                    Image(systemName: "arrow.uturn.forward")
                })
                    .padding(.horizontal)
            }
            Canvas(vc: drawingController)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

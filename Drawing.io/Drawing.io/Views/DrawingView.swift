//
//  ContentView.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @Environment(\.undoManager) private var undoManager
    @Environment(\.presentationMode) private var presentationMode
    @State var drawingController = DrawingViewController()
    @EnvironmentObject var viewModel: ViewModel
    @State private var submitAlert = false
    @State private var clearAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.given)
                    .padding(.horizontal)
                Spacer()
                Button(action: {
                    submitAlert = true
                }, label: {
                    Image(systemName: "checkmark")
                })
                    .alert(isPresented:$submitAlert) {
                        Alert(
                            title: Text("Fertig?"),
                            primaryButton:
                                    .default(Text("Ja")) {
                                        let image = drawingController.saveImg()
                                        viewModel.postData(image)
                                        
                                        presentationMode.wrappedValue.dismiss()
                                    },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding(.horizontal)
            }
            .padding(.vertical)
            HStack {
                Button(action: {
                    clearAlert = true
                }, label: {
                    Image(systemName: "trash")
                })
                    .alert(isPresented:$clearAlert) {
                        Alert(
                            title: Text("Löschen?"),
                            primaryButton:
                                    .destructive(Text("Ja")) {
                                        drawingController.clear()
                                    },
                            secondaryButton: .cancel()
                        )
                    }
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
        }.onAppear {
            viewModel.loadWord()
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingView()
//    }
//}

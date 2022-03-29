//
//  ScoreView.swift
//  Drawing.io
//
//  Created by Anja on 16.03.22.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var counter: Int = 1
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.given)
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .border(.gray)
                Text("Score: x")
                Text("Gesamtscore: y")
                ConfettiCannon(counter: $counter)
            }
            .padding()
            .onTapGesture(){
                counter += 1
            }
            ConfettiCannon(counter: $counter)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                counter += 1
            }
        }
    }
}

//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView()
//    }
//}

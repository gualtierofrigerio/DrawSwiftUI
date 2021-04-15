//
//  DrawRecognizer.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 13/04/21.
//

import SwiftUI

struct DrawRecognizer: View {
    @ObservedObject var viewModel:DrawRecognizerViewModel
    @State var shapes: [SimpleShape] = []
    
    var body: some View {
        VStack {
            Button {
                resetModel()
            } label: {
                Text("Reset model")
                    .foregroundColor(Color.red)
            }
            .padding()
            NavigationLink(destination: RegisterEmoji(viewModel: RegisterEmojiViewModel())) {
                Text("Register new emoji")
            }
            .padding()
            Text("Draw below")
            DrawShapes(viewModel:drawShapesViewModel)
                .frame(height:300)
                .foregroundColor(Color(.systemGray6))
            Button {
                showEmoji()
            } label: {
                Text("Show emoji")
            }
            if viewModel.showEmoji {
                Text(viewModel.emoji)
                    .font(Font.largeTitle)
            }
            Spacer()
        }
    }
    
    // MARK: - Private
    
    private let drawShapesViewModel = DrawShapesViewModel()
    
    private func resetModel() {
        viewModel.resetModel()
    }
    
    private func showEmoji() {
        if let image = drawShapesViewModel.getCGImage() {
            viewModel.predictEmoji(fromImage: image)
        }
        drawShapesViewModel.clear()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DrawRecognizer(viewModel: DrawRecognizerViewModel())
    }
}

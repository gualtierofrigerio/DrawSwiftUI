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
            Button {
                updateModel()
            } label: {
                HStack {
                Text("Update model")
                    if viewModel.showSpinner {
                        Image(systemName: viewModel.spinnerValue)
                    }
                }
            }
            .padding()
            Button {
                showEmojiView.toggle()
            } label: {
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
            NavigationLink(destination: registerEmojiView, isActive: $showEmojiView, label: {})
        }
    }
    
    // MARK: - Private
    
    private let drawShapesViewModel = DrawShapesViewModel()
    @State private var showEmojiView = false
    
    private var registerEmojiView: some View {
        RegisterEmoji(viewModel: RegisterEmojiViewModel())
    }
    
    private func resetModel() {
        viewModel.resetModel()
    }
    
    private func updateModel() {
        viewModel.updateModel()
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

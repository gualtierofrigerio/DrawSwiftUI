//
//  RegisterNewEmoji.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 13/04/21.
//

import SwiftUI

struct RegisterEmoji: View {
    @ObservedObject var viewModel:RegisterEmojiViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if viewModel.showPicker {
            VStack {
                Text("Chose the emoji")
                EmojiPicker(viewModel: EmojiPickerViewModel(), tapAction: viewModel.emojiSelected)
            }
        }
        else {
            VStack {
                Text(viewModel.drawTitle)
                if showImage {
                    Image(uiImage: currentImage)
                }
                else {
                    DrawShapes(viewModel:drawShapesViewModel)
                        .frame(height:300)
                        .foregroundColor(Color(.systemGray6))
                }
                Button {
                    confirmTap()
                } label: {
                    Text(viewModel.confirmMessage)
                }
            }
            .onReceive(viewModel.closePagePublisher) { value in
                if value == true {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private let drawShapesViewModel = DrawShapesViewModel()
    @State private var currentImage = UIImage()
    @State private var showImage = false
    
    private func confirmTap() {
        let image = drawShapesViewModel.getCGImage()
        viewModel.confirmTap(image: image)
        drawShapesViewModel.clear()
    }
    
    private func newShapeTap() {
        drawShapesViewModel.clear()
    }
}

struct RegisterNewEmoji_Previews: PreviewProvider {
    static var previews: some View {
        RegisterEmoji(viewModel:RegisterEmojiViewModel())
    }
}

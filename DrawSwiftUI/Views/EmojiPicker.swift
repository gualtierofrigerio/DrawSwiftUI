//
//  EmojiPicker.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 11/04/21.
//

import SwiftUI

struct EmojiPicker: View {
    let viewModel:EmojiPickerViewModel
    let tapAction:(String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.emojiArray.indices) { index in
                    Button {
                        tapAction(String(viewModel.emojiArray[index]))
                    } label: {
                        Text(String(viewModel.emojiArray[index]))
                            .font(Font.largeTitle)
                    }
                }
            }
        }
    }
    
    private let columns:[GridItem] = [
        GridItem(.fixed(60), spacing:5),
        GridItem(.fixed(60), spacing:5),
        GridItem(.fixed(60), spacing:5),
        GridItem(.fixed(60), spacing:5),
        GridItem(.fixed(60), spacing:5)
    ]
}

struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker(viewModel: EmojiPickerViewModel(), tapAction: {string in })
    }
}

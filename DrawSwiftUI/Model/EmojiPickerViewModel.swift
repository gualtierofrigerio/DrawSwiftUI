//
//  EmojiPickerViewModel.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 11/04/21.
//

import Foundation

class EmojiPickerViewModel {
        
    let emojiArray = getEmojiArray()
    var selectedEmoji:String.Element?
    
    // MARK: - Private
    
    private static func getEmojiArray() -> [String.Element] {
        let defaultArray = Array("😀😁😂🤣😃")
        
        guard let emojiURL = Bundle.main.url(forResource: "emoji", withExtension: "txt") else {
            return defaultArray
        }
        
        guard let emojiString = try? String(contentsOf: emojiURL) else {
            return defaultArray
        }
        
        return Array(emojiString)
    }
}

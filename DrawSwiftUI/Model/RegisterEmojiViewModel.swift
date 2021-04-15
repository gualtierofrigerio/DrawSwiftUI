//
//  RegisterEmojiViewModel.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 12/04/21.
//

import Foundation
import Combine
import CoreGraphics

class RegisterEmojiViewModel: ObservableObject {
    @Published var showPicker = true
    @Published var title = "Register new emoji"
    @Published var drawTitle = ""
    @Published var confirmMessage = "Confirm"
    @Published var closePage = false
    
    var closePagePublisher: AnyPublisher<Bool, Never> {
        $closePage.eraseToAnyPublisher()
    }
    
    func confirmTap(image:CGImage?) {
        guard let image = image  else { return }
        images.append(image)
        iterations += 1
        if iterations == 2 {
            confirmMessage = "Confirm and save"
        }
        if iterations == 3 {
            if let selectedEmoji = selectedEmoji {
                CoreMLHelper.shared.updateModel(withImages: images, forValue: selectedEmoji) { [weak self] in
                    self?.closePage = true
                    self?.showPicker = true
                }
            }
            else {
                closePage = true
                self.showPicker = true
            }
        }
    }
    
    func emojiSelected(emoji:String) {
        print("selected \(emoji)")
        selectedEmoji = emoji
        showPicker = false
        drawTitle = "Draw in the space below"
    }
    
    func getImages() -> [CGImage] {
        images
    }
    
    private var images:[CGImage] = []
    private var iterations = 0
    private var selectedEmoji:String?
}

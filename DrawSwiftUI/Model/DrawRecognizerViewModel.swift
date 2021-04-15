//
//  DrawRecognizerViewModel.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 13/04/21.
//

import Foundation
import CoreGraphics

class DrawRecognizerViewModel: ObservableObject {
    @Published var emoji:String = ""
    @Published var showEmoji = false
    
    func predictEmoji(fromImage image:CGImage) {
        if let predictedString = CoreMLHelper.shared.predictString(fromImage: image) {
            emoji = predictedString
            showEmoji = true
        }
        else {
            emoji = ""
            showEmoji = false
        }
    }
    
    func resetModel() {
        CoreMLHelper.shared.resetModel()
    }
    
    // MARK: - Private
    
}

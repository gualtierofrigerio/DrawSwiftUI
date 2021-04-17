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
    @Published var showSpinner = false
    @Published var spinnerValue:String = ""
    
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
    
    func updateModel() {
        showSpinner = true
        spinnerValue = "hourglass"
        CoreMLHelper.shared.commitUpdates {
            DispatchQueue.main.async {
                self.spinnerValue = "hand.thumbsup.fill"
            }
        }
    }
    
    // MARK: - Private
    
}

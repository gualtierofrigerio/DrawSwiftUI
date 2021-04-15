//
//  DrawShapesViewModel.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import Foundation
import Combine
import SwiftUI

class DrawShapesViewModel: ObservableObject {
    @Published var shapes:[SimpleShape] = []
    
    func addPoint(_ point:CGPoint) {
        var shape = getCurrentShape()
        shape.points.append(point)
        shapes.removeLast()
        shapes.append(shape)
    }
    
    func clear() {
        shapes = []
    }
    
    func endShape(size:CGSize) {
        viewSize = size
        newShape()
    }
    
    func getCGImage() -> CGImage? {
        ImageUtils.imageFromShapes(shapes, size: viewSize).cgImage
    }
    
    func getImage() -> UIImage {
        ImageUtils.imageFromShapes(shapes, size: viewSize)
    }
    
    // MARK: - Private
    
    private var viewSize:CGSize = CGSize.zero
    
    private func getCurrentShape() -> SimpleShape {
        if let shape = shapes.last {
            return shape
        }
        return newShape()
    }
    
    @discardableResult private func newShape() -> SimpleShape {
        let newShape = SimpleShape(points: [], color: .black, width: 3)
        shapes.append(newShape)
        return newShape
    }
}

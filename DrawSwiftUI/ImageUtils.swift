//
//  ImageUtils.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import Foundation
import UIKit

class ImageUtils {
    static func imageFromShapes(_ shapes:[SimpleShape], size:CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            for shape in shapes {
                if shape.points.count > 0 {
                    context.cgContext.setStrokeColor(shape.color.cgColor ?? UIColor.black.cgColor)
                    context.cgContext.setLineWidth(shape.width)
                    context.cgContext.move(to: shape.points[0])
                    for p in 1..<shape.points.count {
                        context.cgContext.addLine(to: shape.points[p])
                    }
                }
            }
            context.cgContext.drawPath(using: .stroke)
        }
        return image
    }
}

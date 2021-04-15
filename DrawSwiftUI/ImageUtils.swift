//
//  ImageUtils.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import Foundation
import UIKit

class ImageUtils {
    static func getRect(containingShapes shapes:[SimpleShape]) -> CGRect {
        var minimumX:CGFloat = -1
        var minimumY:CGFloat = -1
        var maximumX:CGFloat = 0
        var maximumY:CGFloat = 0
        
        var lineWidth:CGFloat = 1.0
        
        for shape in shapes {
            if shape.width > lineWidth {
                lineWidth = shape.width
            }
            for point in shape.points {
                if point.x < minimumX || minimumX < 0 {
                    minimumX = point.x
                }
                if point.y < minimumY || minimumY < 0 {
                    minimumY = point.y
                }
                if point.x > maximumX {
                    maximumX = point.x
                }
                if point.y > maximumY {
                    maximumY = point.y
                }
            }
        }
        minimumX -= lineWidth * 2
        minimumY -= lineWidth * 2
        maximumX += lineWidth * 2
        maximumY += lineWidth * 2
        
        return CGRect(x: minimumX, y: minimumY, width: maximumX - minimumX, height: maximumY - minimumY)
    }
    
    static func imageFromShapes(_ shapes:[SimpleShape], size:CGSize) -> UIImage {
        let rect = getRect(containingShapes: shapes)
        let modifiedShapes = shapes.map {
            $0.changePoints(withRect:rect)
        }
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = renderer.image { context in
            for shape in modifiedShapes {
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
    
    static func whiteTintedImage(fromImage image:CGImage) -> CGImage? {
        let parameters = [kCIInputBrightnessKey: 1.0]
        let ciImage = CIImage(cgImage: image).applyingFilter("CIColorControls",
                                                             parameters: parameters)
        return ciContext.createCGImage(ciImage, from: ciImage.extent)
    }
    
    private static let ciContext = CIContext()
}

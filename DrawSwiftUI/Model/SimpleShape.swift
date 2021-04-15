//
//  SimpleShape.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import Foundation
import SwiftUI

struct SimpleShape {
    var points:[CGPoint] // points to make a path
    var color:Color // stroke color
    var width:CGFloat // stroke line width
    var id:UUID = UUID() // necessary to use in ForEach
    
    mutating func addPoint(_ point:CGPoint) {
        points.append(point)
    }
}

extension SimpleShape {
    func changePoints(withRect rect:CGRect) -> Self {
        let newPoints = points.map {
            CGPoint(x: $0.x - rect.origin.x, y: $0.y - rect.origin.y)
        }
        return SimpleShape(points: newPoints, color: self.color, width: self.width)
    }
}


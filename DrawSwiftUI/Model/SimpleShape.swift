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


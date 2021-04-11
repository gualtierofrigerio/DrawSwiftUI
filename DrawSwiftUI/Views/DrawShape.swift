//
//  DrawShape.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import SwiftUI

struct DrawShape: Shape {
    var points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        if points.count == 0 {
            return path
        }

        path.move(to: points[0])
        for index in 1..<points.count {
            path.addLine(to: points[index])

        }
        return path
    }
}

struct DrawShape_Previews: PreviewProvider {
    static var previews: some View {
        DrawShape(points:[])
    }
}

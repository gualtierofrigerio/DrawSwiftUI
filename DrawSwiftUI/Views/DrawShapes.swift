//
//  DrawShapes.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import SwiftUI

struct DrawShapes: View {
    @ObservedObject var viewModel:DrawShapesViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Rectangle()
                    .gesture(DragGesture(coordinateSpace:.local).onChanged( { value in
                        addPoint(value, geometry:geometry)
                    })
                    .onEnded( { value in
                        endGesture(size:geometry.size)
                    }))
            }
            ForEach(viewModel.shapes, id:\.id) { shape in
                DrawShape(points: shape.points)
                    .stroke(lineWidth: shape.width)
                    .foregroundColor(shape.color)
            }
        }
    }
    
    // MARK: - Private
        
    /// Called every time a new point is detected by the DragGesture
    /// - Parameters:
    ///   - value: the value returned by DragGesture
    ///   - geometry: GeometryProxy returned by GeometryReader
    private func addPoint(_ value: DragGesture.Value, geometry:GeometryProxy) {
        let point = value.location
        let size = geometry.size
        // we skip a point if x or y are negative
        // or if they are bigger than the width/height
        // so we don't draw points outside the view
        if point.y < 0 ||
            point.y > size.height ||
            point.x < 0 ||
            point.x > size.width {
            viewModel.endShape(size:size)
            return
        }
        viewModel.addPoint(value.location)
    }
    
    /// Called when the gesture ends or when the drag reaches a point outside the view
    /// - Parameter size: size of the view from GeometryReader
    private func endGesture(size:CGSize) {
        viewModel.endShape(size:size)
    }
}

struct DrawShapes_Previews: PreviewProvider {
    static var previews: some View {
        DrawShapes(viewModel:DrawShapesViewModel())
    }
}

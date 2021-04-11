//
//  ContentView.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 10/04/21.
//

import SwiftUI

struct ContentView: View {
    @State var shapes: [SimpleShape] = []
    
    var body: some View {
        VStack {
            Text("Draw below")
            DrawShapes(viewModel:drawShapesViewModel)
                .frame(height:300)
                .foregroundColor(Color(.systemGray6))
            Button {
                showImage = true
            } label: {
                Text("Show image")
            }
            if showImage {
                shapeImage
            }
        }
    }
    
    // MARK: - Private
    
    private var drawShapesViewModel = DrawShapesViewModel()
    @State private var showImage = false
    
    private var shapeImage:Image {
        Image(uiImage: drawShapesViewModel.getImage())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

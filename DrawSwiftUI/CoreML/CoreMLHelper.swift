//
//  CoreMLHelper.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 13/04/21.
//

import Foundation
import CoreML
import UIKit

class CoreMLHelper {
    static let shared = CoreMLHelper()
    
    init() {
        modelUpdater = ModelUpdater(modelURL: Self.documentsModelURL, bundleModelURL: Self.bundleModelURL)
        reloadModel()
    }
    
    func commitUpdates(completion: @escaping() -> Void) {
        let batch = MLArrayBatchProvider(array: featuresToUpdate)
        modelUpdater.updateModel(withData: batch) { success in
            if success {
                print("model updated")
                self.featuresToUpdate = []
                self.reloadModel()
            }
            completion()
        }
    }
    
    func predictString(fromImage cgImage:CGImage) -> String? {
        guard let model = currentModel,
              let imageConstraint = imageConstraint,
              let inputValue = try? MLFeatureValue(cgImage: cgImage, constraint: imageConstraint),
              let pixelBuffer = inputValue.imageBufferValue,
              let prediction = try? model.prediction(drawing: pixelBuffer)
            else { return nil }
        print("prediction \(prediction.labelProbs)")
        
        return prediction.label
    }
    
    func resetModel() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: Self.documentsModelURL.absoluteString) {
            do {
                try fileManager.removeItem(atPath: Self.documentsModelURL.absoluteString)
            }
            catch (let error) {
                print("error while removing model in Documents \(error)")
            }
        }
    }
    
    func updateModel(withImages images:[CGImage], forValue:String, completion:@escaping ()-> Void) {
        guard let constraint = imageConstraint else {
            completion()
            return
        }
        
        let features = Self.getFeatureProviders(fromImages: images, constraint: constraint, outputString: forValue)
        self.featuresToUpdate.append(contentsOf: features)
        completion()
        
        /*let batch = Self.getBatchProvider(fromImages: images,
                                                 constraint: constraint,
                                                 outputString: forValue)
        
        
        modelUpdater.updateModel(withData: batch) { success in
            if success {
                self.reloadModel()
            }
            completion()
        }*/
    }
    
    // MARK: - Private
    
    private var imageConstraint:MLImageConstraint? {
        guard let model = currentModel else { return nil }
        
        let description = model.model.modelDescription
        let inputName = "drawing"
        if let imageInputDescription = description.inputDescriptionsByName[inputName] {
            return imageInputDescription.imageConstraint
        }
        return nil
    }
    
    private var featuresToUpdate:[MLFeatureProvider] = []
    private var currentModel:UpdatableDrawingClassifier?
    private let modelUpdater:ModelUpdater
    
    private func reloadModel() {
        if let model = try? UpdatableDrawingClassifier(contentsOf: Self.documentsModelURL) {
            self.currentModel = model
        }
        else {
            if let bundleModelURL = Self.bundleModelURL {
                self.currentModel = try? UpdatableDrawingClassifier(contentsOf: bundleModelURL)
            }
        }
    }
    
    // MARK: - Private static
    
    private static let modelFileName = "UpdatableDrawingClassifier"
    
    private static var bundleModelURL:URL? {
        Bundle.main.url(forResource: Self.modelFileName, withExtension: "mlmodelc")
    }
    private static var documentsModelURL:URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("\(modelFileName).mlmodelc")
    }
    
    private static func getBatchProvider(fromImages images:[CGImage],
                                 constraint:MLImageConstraint,
                                 outputString:String) -> MLBatchProvider {
        var featureProviders = [MLFeatureProvider]()

        let inputName = "drawing"
        let outputName = "label"
        
        for image in images {
            if let inputValue = try? MLFeatureValue(cgImage: image, constraint: constraint) {
                let outputValue = MLFeatureValue(string: outputString)
                
                let dataPointFeatures: [String: MLFeatureValue] = [inputName: inputValue,
                                                                   outputName: outputValue]
                
                if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
                    featureProviders.append(provider)
                }
            }
        }
        
       return MLArrayBatchProvider(array: featureProviders)
    }
    
    private static func getFeatureProviders(fromImages images:[CGImage],
                                            constraint:MLImageConstraint,
                                            outputString:String) -> [MLFeatureProvider] {
        var featureProviders = [MLFeatureProvider]()

        let inputName = "drawing"
        let outputName = "label"

        for image in images {
            if let inputValue = try? MLFeatureValue(cgImage: image, constraint: constraint) {
                let outputValue = MLFeatureValue(string: outputString)
                
                let dataPointFeatures: [String: MLFeatureValue] = [inputName: inputValue,
                                                                   outputName: outputValue]
                
                if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
                    featureProviders.append(provider)
                }
            }
        }
        return featureProviders
    }
}

//
//  ModelUpdater.swift
//  DrawSwiftUI
//
//  Created by Gualtiero Frigerio on 13/04/21.
//

import Foundation
import CoreML

class ModelUpdater {
    init(modelURL url:URL, bundleModelURL:URL?) {
        self.bundleModelURL = bundleModelURL
        self.modelURL = url
    }
    
    func updateModel(withData trainingData:MLBatchProvider, completion: @escaping (Bool) -> Void) {
        guard let updateTask = createUpdateTask(trainingData: trainingData)
            else {
                print("Could't create an MLUpdateTask.")
                completion(false)
                return
        }
        self.completion = completion
        updateTask.resume()
    }
    
    // MARK: - Private
    
    private var bundleModelURL:URL?
    private var completion:((Bool) -> Void)?
    private var modelURL:URL
    
    private func createUpdateTask(trainingData:MLBatchProvider) -> MLUpdateTask? {
        if let updateTaskDocuments = try? MLUpdateTask(forModelAt: modelURL,
                                                       trainingData: trainingData,
                                                       configuration: nil,
                                                       completionHandler: updateCompletionHandler) {
            return updateTaskDocuments
        }
        if let bundleModelURL = bundleModelURL,
           let updateTaskBundle = try? MLUpdateTask(forModelAt: bundleModelURL,
                                                    trainingData: trainingData,
                                                    configuration: nil,
                                                    completionHandler: updateCompletionHandler) {
            return updateTaskBundle
        }
        return nil
    }
    
    private func saveUpdatedModel(_ model:MLWritable) -> Bool {
        do {
            try model.write(to: modelURL)
        }
        catch (let error) {
            print("error while saving model \(error)")
            return false
        }
        return true
    }
    
    private func updateCompletionHandler(updatedContext:MLUpdateContext) {
        let saved = saveUpdatedModel(updatedContext.model)
        completion?(saved)
    }
}

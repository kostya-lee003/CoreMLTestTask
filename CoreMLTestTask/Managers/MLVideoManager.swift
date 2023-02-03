//
//  MachineLearningManager.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import Foundation
import UIKit
import CoreML
import Vision

public class MLVideoManager {
    private var sourceImages = [UIImage]()
    private var resultImages = [UIImage]()
    private var imageDurations = [Double]()
    
    public var imageRequestDidComplete: (UIImage) -> Void = {_ in }
        
    let imageConverter = MLImageConverter()
    
    public func fetchSourceImage() {
        imageConverter.imageRequestDidComplete = { [weak self] image in
            self?.imageRequestDidComplete(image)
        }
        setTemplateSources()
        imageConverter.requestImageConversion(with: sourceImages[0])
    }
    
    /// Fetches all 'images' from setTemplateSources() additionaly executing resizeAndRotate, and then creates a video
    public func fetchSource(completion: @escaping (_ videoURL: URL) -> Void) {
        setTemplateSources()
        
    }
    
    /// Generates video from 'images' and 'imageDurations' using SwiftVideoGenerator
    private func generateVideo() {
        
    }
    
    /// Sets template images and audio that was provided in test task requirements
    private func setTemplateSources() {
        self.sourceImages = [group]
    }
    
}

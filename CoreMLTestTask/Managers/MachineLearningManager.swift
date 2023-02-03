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
    
    private var inputImage: UIImage?
    private var outputImage: UIImage?
    
    public var imageRequestDidComplete: (UIImage) -> Void = {_ in }
    
    public func fetchSourceImage() {
        setTemplateSources()
        requestImageConversion(with: sourceImages[0])
    }
    
    
    /// Fetches all 'images' from setTemplateSources() additionaly executing resizeAndRotate, and then creates a video
    public func fetchSource(completion: @escaping (_ videoURL: URL) -> Void) {
        setTemplateSources()
        
    }
    
    /// Requests CoreML models to divide source image on maskedForeground and maskedBackground
    public func requestImageConversion(with sourceImage: UIImage) {
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else { return }

        inputImage = (sourceImage.copy() as? UIImage)
        outputImage = (sourceImage.copy() as? UIImage)
        guard let inputImage = inputImage else { return }
        
        let requestForeground = VNCoreMLRequest(model: model, completionHandler: visionRequestDidComplete)
        requestForeground.imageCropAndScaleOption = .scaleFill
        
        DispatchQueue.global().async {
            let foregroundHandler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
            do {
                try foregroundHandler.perform([requestForeground])
            } catch {
                print(error)
            }
        }
    }
    
    /// Generates video from 'images' and 'imageDurations' using SwiftVideoGenerator
    private func generateVideo() {
        
    }
    
    /// Resizes image to fit 'size' and rotates to 'rotateOffset'
    private func resizeAndRotate(image: UIImage, with size: CGSize, with rotateOffset: Double) {
        
    }
    
    /// Sets template images and audio that was provided in test task requirements
    private func setTemplateSources() {
        self.sourceImages = [group]
    }
    
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                let segmentationmap = observations.first?.featureValue.multiArrayValue {
                
                let segmentationMask = segmentationmap.image(min: 0, max: 1)

                self.outputImage = segmentationMask!.resizedImage(for: self.inputImage!.size)!
                
                self.maskImage(on: person_sky)
            }
        }
    }
    
    func maskImage(on bgImage: UIImage) {
        if inputImage == nil || outputImage == nil { return }
        
        let beginImage = CIImage(cgImage: inputImage!.cgImage!)
        let background = CIImage(cgImage: bgImage.cgImage!)
        let mask = CIImage(cgImage: outputImage!.cgImage!)
        
        self.inputImage = self.maskCompose(beginImage: beginImage, background: background, mask: mask)
        self.imageRequestDidComplete(self.inputImage!)
    }
    
    func maskCompose(beginImage: CIImage, background: CIImage, mask: CIImage) -> UIImage {
        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: [
                                        kCIInputImageKey: beginImage,
                                        kCIInputBackgroundImageKey: background,
                                        kCIInputMaskImageKey: mask])?.outputImage
        {
            let ciContext = CIContext(options: nil)
            let filteredImageRef = ciContext.createCGImage(compositeImage, from: compositeImage.extent)
            return UIImage(cgImage: filteredImageRef!)
        }
        return UIImage()
    }
}

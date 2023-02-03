//
//  MLImageConverter.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI
import CoreML
import CoreImage
import Vision

public class MLImageConverter {
    private var inputImage: UIImage?
    private var outputImage: UIImage?
    var currentBackgroundImage: UIImage?
    
    public var imageRequestDidComplete: (UIImage) -> Void = {_ in }
    
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
        self.currentBackgroundImage = self.inputImage
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
    
    /// Resizes image to fit 'size' and rotates to 'rotateOffset'
    private func resizeAndRotate(image: UIImage, with size: CGSize, with rotateOffset: Double) {
        
    }
}

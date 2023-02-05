//
//  MLImageConverter.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI
import UIKit
import CoreML
import CoreImage
import Vision
import AVFoundation

public class MLImageConverter {
    var inputImage: UIImage?
    var outputImage: UIImage?
    var currentBackgroundImage: UIImage?
    
    /// Requests CoreML models to divide source image on maskedForeground and maskedBackground
    public func requestImageConversion(with sourceImage: UIImage, completion: @escaping (VNRequest, Error?) -> Void) {
        guard let model = try? VNCoreMLModel(for: DeepLabV3(configuration: .init()).model) else { return }
        
        inputImage = (sourceImage.copy() as? UIImage)
        outputImage = (sourceImage.copy() as? UIImage)
        guard let inputImage = inputImage else { return }
        
        let requestForeground = VNCoreMLRequest(model: model, completionHandler: completion)
        requestForeground.imageCropAndScaleOption = .scaleFill
        
        DispatchQueue.main.async {
            let foregroundHandler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
            do {
                try foregroundHandler.perform([requestForeground])
            } catch {
                print(error)
            }
        }
    }
    
    func maskImage(on bgImage: UIImage, completion: @escaping () -> Void) {
        if inputImage == nil || outputImage == nil { return }
        
        let beginImage = CIImage(cgImage: inputImage!.cgImage!)
        let background = bgImage.cgImage
        let mask = CIImage(cgImage: outputImage!.cgImage!)
        
        self.inputImage = self.maskCompose(beginImage: beginImage, background: background, mask: mask)
        completion()
    }
    
    func maskCompose(beginImage: CIImage, background: CGImage?, mask: CIImage) -> UIImage {
        
        var params = [String : Any]()
        if let background = background {
            params = [
                kCIInputImageKey: beginImage,
                kCIInputBackgroundImageKey: CIImage(cgImage: background),
                kCIInputMaskImageKey: mask
            ]
        } else {
            params = [
                kCIInputImageKey: beginImage,
                kCIInputMaskImageKey: mask
            ]
        }
        if let compositeImage = CIFilter(name: "CIBlendWithMask", parameters: params)?.outputImage
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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) {

        let maxSize = CGSize(width: newWidth, height: commonImageRatio * newWidth)

        let availableRect = AVFoundation.AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
   }
}

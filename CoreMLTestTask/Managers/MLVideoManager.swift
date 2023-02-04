//
//  MachineLearningManager.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import Foundation
import UIKit
import CoreML
import AVKit
import AVFoundation
import Vision

public class MLVideoManager {
    private var sourceImages = [UIImage]()
    private var resultImages = [UIImage]()
    private var imageDurations = [Double]()
    
    public var videoGenerationDidComplete: (URL) -> Void = {_ in }
        
    let imageConverter = MLImageConverter()
    
    var backgroundImage = UIImage()
    
    /// Fetches all 'images' additionaly executing resizeAndRotate using dispatchGroup, and then calls completion() in notify
    public func fetchImages(completion: @escaping () -> Void) {
        resultImages = []
        imageDurations = []
        
        let dispatchGroup = DispatchGroup()
        
        self.resultImages.append(group)
        
        dispatchGroup.enter()
        imageConverter.currentBackgroundImage = group
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageConverter.requestImageConversion(with: person_abandonedBuilding) { [weak imageConverter = self.imageConverter] request, error in
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                    let segmentationmap = observations.first?.featureValue.multiArrayValue, let imageConverter = imageConverter {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)

                    imageConverter.outputImage = segmentationMask!.resizedImage(for: imageConverter.inputImage!.size)!
                    
                    imageConverter.maskImage(on: group.copy() as! UIImage) {
                        self.resultImages.append(imageConverter.inputImage!)
                        self.resultImages.append(person_abandonedBuilding.copy() as! UIImage)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.enter()
        imageConverter.currentBackgroundImage = person_abandonedBuilding
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageConverter.requestImageConversion(with: skate) { [weak imageConverter = self.imageConverter] request, error in
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                    let segmentationmap = observations.first?.featureValue.multiArrayValue, let imageConverter = imageConverter {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)

                    imageConverter.outputImage = segmentationMask!.resizedImage(for: imageConverter.inputImage!.size)!
                    
                    imageConverter.maskImage(on: person_abandonedBuilding.copy() as! UIImage) {
                        self.resultImages.append(imageConverter.inputImage!)
                        self.resultImages.append(skate.copy() as! UIImage)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.enter()
        imageConverter.currentBackgroundImage = skate
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageConverter.requestImageConversion(with: person_sky) { [weak imageConverter = self.imageConverter] request, error in
                if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                    let segmentationmap = observations.first?.featureValue.multiArrayValue, let imageConverter = imageConverter {
                    
                    let segmentationMask = segmentationmap.image(min: 0, max: 1)

                    imageConverter.outputImage = segmentationMask!.resizedImage(for: imageConverter.inputImage!.size)!
                    
                    imageConverter.maskImage(on: skate.copy() as! UIImage) {
                        self.resultImages.append(imageConverter.inputImage!)
                        let skyImage = person_sky.copy() as! UIImage
                        self.resultImages.append(skyImage)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func appendRequestedImage(with group: DispatchGroup, image: UIImage) {
        
    }
    
    func appendResizedImage(with group: DispatchGroup, width: CGFloat) {
        group.enter()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let image = (self.resultImages.last!.copy() as! UIImage)
            self.imageConverter.resizeImage(image: image, newWidth: width)
            self.resultImages.append(image)
            group.leave()
        }
    }
    
    public func generateVideoURL(completion: @escaping (_ videoURL: URL) -> Void) {
        if let audioURL = Bundle.main.url(forResource: "music", withExtension: Mp3Extension) {
            
            resultImages.forEach { _ in
                imageDurations.append(1.0 / Double(resultImages.count))
            }
            
            print(1.0 / Double(resultImages.count))
            print(imageDurations)
            print(resultImages.count)
            print(imageDurations.count)
          
          VideoGenerator.fileName = MultipleSingleMovieFileName
          VideoGenerator.shouldOptimiseImageForVideo = true
          VideoGenerator.current.generate(withImages: resultImages, videoDurations: imageDurations, andAudios: [audioURL], andType: .singleAudioMultipleImage, { (progress) in
          print(progress)
          }) { (result) in
            switch result {
            case .success(let url):
              print(url)
              completion(url)
            case .failure(let error):
              print(error)
//              self.createAlertView(message: error.localizedDescription)
            }
          }
        } else {
//          self.createAlertView(message: MissingAudioFiles)
        }
    }
    
    /// Generates video from 'images' and 'imageDurations' using SwiftVideoGenerator
    public func generateVideo() {
        checkIfVideoExists()
        setTemplateSources()
        fetchImages { [weak self] in
            self?.generateVideoURL { videoURL in
                self?.videoGenerationDidComplete(videoURL)
            }
        }
    }
    
    /// Sets template images that was provided in test task requirements
    private func setTemplateSources() {
        self.sourceImages = templateImageSet
    }
    
    func checkIfVideoExists() {
        if let videoURL = Bundle.main.url(forResource: "newVideo", withExtension: "mp4") {
            self.videoGenerationDidComplete(videoURL)
        }
    }
}

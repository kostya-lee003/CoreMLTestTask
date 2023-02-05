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
        
//    let imageConverter = MLImageConverter()
    
    
    /// Fetches all 'images' additionaly executing resizeAndRotate using dispatchGroup, and then calls completion() in notify
    public func fetchImages(completion: @escaping () -> Void) {
        resultImages = []
        imageDurations = []
        
        let dispatchGroup = DispatchGroup()
        
        self.resultImages.append(group)
        
        DispatchQueue.global().sync {
            dispatchGroup.enter()
            processRequestedImage(with: dispatchGroup, image: person_abandonedBuilding, onBackground: group)
        }
        
        DispatchQueue.global().sync {
            dispatchGroup.enter()
            processRequestedImage(with: dispatchGroup, image: skate, onBackground: person_abandonedBuilding)
        }
        
        DispatchQueue.global().sync {
            dispatchGroup.enter()
            processRequestedImage(with: dispatchGroup, image: person_sky, onBackground: skate)
        }
        
        DispatchQueue.global().sync {
            dispatchGroup.enter()
            processRequestedImage(with: dispatchGroup, image: person_garage, onBackground: person_sky)
        }
        
        DispatchQueue.global().sync {
            dispatchGroup.enter()
            processRequestedImage(with: dispatchGroup, image: person_jump, onBackground: person_garage)
        }
        
        DispatchQueue.global().sync {
            dispatchGroup.enter()
            processRequestedImage(with: dispatchGroup, image: person_roof, onBackground: person_jump)
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func processRequestedImage(with dispatchGroup: DispatchGroup, image: UIImage, onBackground bg: UIImage = UIImage()) {
        let imageConverter = MLImageConverter()
        imageConverter.currentBackgroundImage = skate
        
        imageConverter.requestImageConversion(with: image) { [weak self] request, error in
            if let observations = request.results as? [VNCoreMLFeatureValueObservation],
                let segmentationmap = observations.first?.featureValue.multiArrayValue {
                
                let segmentationMask = segmentationmap.image(min: 0, max: 1)

                imageConverter.outputImage = segmentationMask!.resizedImage(for: imageConverter.inputImage!.size)!
                
                imageConverter.maskImage(on: bg) {
                    self?.resultImages.append(imageConverter.inputImage!)
                    self?.resultImages.append(image)
                    dispatchGroup.leave()
                }
            }
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

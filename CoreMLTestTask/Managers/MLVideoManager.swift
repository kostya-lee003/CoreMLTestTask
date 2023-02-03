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
    
//    public var imageRequestDidComplete: (UIImage) -> Void = {_ in }
    public var videoGenerationDidComplete: (URL) -> Void = {_ in }
        
    let imageConverter = MLImageConverter()
    
    // Temporary method!!!
    public func fetchSourceImage() {
        checkIfVideoExists()
        imageConverter.imageRequestDidComplete = { [weak self] image in
            self?.resultImages.append(image)
//            self?.imageRequestDidComplete(image)
            self?.generateVideoURL { videoURL in
                self?.videoGenerationDidComplete(videoURL)
            }
        }
        setTemplateSources()
        imageConverter.requestImageConversion(with: sourceImages[0])
    }
    
    /// Fetches all 'images' from setTemplateSources() additionaly executing resizeAndRotate using dispatchGroup, and then calls generateVideoURL()
    public func fetchImages(completion: @escaping () -> Void) {
        resultImages = []
        imageDurations = [0.2, 0.2, 0.2, 0.2, 0.2]
        
        let dispatchGroup = DispatchGroup()
        
        // appends image 'group' to result images
        let image1 = group
        resultImages.append(image1)
        
        dispatchGroup.enter()
        imageConverter.currentBackgroundImage = group
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageConverter.requestImageConversion(with: self.sourceImages[1]) // person_abandonedBuilding
            self.imageConverter.imageRequestDidComplete = { [weak self] image in
                
                self?.resultImages.append(image)
                dispatchGroup.leave()
            }
        }
        
        let image2 = (resultImages.last!.copy() as! UIImage).resizedImage(for: CGSize(width: 280.0, height: 280 * commonImageRatio)) ?? (person_abandonedBuilding.copy() as! UIImage)
        self.resultImages.append(image2)
        
        let image3 = (image2.copy() as! UIImage).resizedImage(for: CGSize(width: 320.0, height: 320 * commonImageRatio)) ?? (person_abandonedBuilding.copy() as! UIImage)
        self.resultImages.append(image3)
        
        let image4 = (image2.copy() as! UIImage).resizedImage(for: CGSize(width: 360.0, height: 360 * commonImageRatio)) ?? (person_abandonedBuilding.copy() as! UIImage)
        self.resultImages.append(image4)
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    public func generateVideoURL(completion: @escaping (_ videoURL: URL) -> Void) {
        if let audioURL = Bundle.main.url(forResource: "music", withExtension: Mp3Extension) {
          
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
    
    /// Sets template images and audio that was provided in test task requirements
    private func setTemplateSources() {
        self.sourceImages = templateImageSet
    }
    
    func checkIfVideoExists() {
        if let videoURL = Bundle.main.url(forResource: "newVideo", withExtension: "mp4") {
            self.videoGenerationDidComplete(videoURL)
        }
    }
}

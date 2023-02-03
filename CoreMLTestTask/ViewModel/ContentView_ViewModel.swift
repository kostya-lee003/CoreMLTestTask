//
//  ContentView_ViewModel.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        let machineLearningManager = MLVideoManager()
        var viewDidLoad = false
        
        @Published var maskedImage: UIImage?
        
        func runVisionRequest() {
            machineLearningManager.fetchSourceImage()
        }
        
        func onViewDidLoad() {
            machineLearningManager.imageRequestDidComplete = { [weak self] image in
                self?.maskedImage = image
            }
        }
    }
}

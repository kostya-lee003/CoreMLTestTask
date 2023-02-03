//
//  ContentView_ViewModel.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var listItems = templateImageSet
        @Published var bgImage: UIImage?
        
        let mlVideoManager = MLVideoManager()
        
        var viewDidLoad = false
                
        func runVisionRequest() {
            mlVideoManager.fetchSourceImage()
        }
        
        func generateVideo() {
            
        }
        
        func onViewDidLoad() {
            mlVideoManager.imageRequestDidComplete = { [weak self] image in
//                self?.maskedImage = image
            }
        }
    }
}

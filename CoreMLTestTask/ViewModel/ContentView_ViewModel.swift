//
//  ContentView_ViewModel.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI
import AVKit

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var listItems = templateImageSet
        @Published var bgImage: UIImage?
        @Published var showLoadingView = false
        @Published var isVideoGenerated = false
        
        var videoURL: URL?
                
        let mlVideoManager = MLVideoManager()
        
        var viewDidLoad = false
                
        func generateVideo() {
            mlVideoManager.generateVideo()
        }
        
        func onViewDidLoad() {
            mlVideoManager.videoGenerationDidComplete = { [weak self] url in
                self?.videoURL = url
                self?.showLoadingView = false
                self?.isVideoGenerated = true
            }
        }
    }
}

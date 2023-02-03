//
//  ContentView.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    var imageSize = UIImage(named: "group")!.size
    
    var body: some View {
        VStack {
            Image(uiImage: group)
                .resizable()
                .scaledToFit()
                .frame(width: 230)
            Button("Convert") {
                viewModel.runVisionRequest()
            }
            HStack {
                Image(uiImage: viewModel.maskedImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220 * imageSize.height / imageSize.width)
                    .background(Color.gray)
            }
        }
        .padding()
        .onAppear {
            if !viewModel.viewDidLoad {
                viewModel.onViewDidLoad()
                viewModel.viewDidLoad = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

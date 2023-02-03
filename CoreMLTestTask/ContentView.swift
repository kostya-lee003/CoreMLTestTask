//
//  ContentView.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    var imageSize = CGSize(width: 200.0, height: 289.7)
    
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(alignment: .leading) {
                Text("Images")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                TabView {
                    ForEach(viewModel.listItems, id: \.self) { element in
                        Image(uiImage: element)
                            .resizable()
                            .cornerRadius(24)
                            .scaledToFit()
                            .frame(width: 280, height: 280 * imageSize.height / imageSize.width)
                            .onAppear {
                                withAnimation(.easeInOut) {
                                    viewModel.bgImage = element
                                }
                            }
                    }
                }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
            Text("Sound")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            AudioPlayerView()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 120, trailing: 0))
            Button {
                viewModel.generateVideo()
            } label: {
                Text("Apply effects >")
                    .font(.title2)
                    .fontWeight(.medium)
            }
        }
        .background(content: {
            Image(uiImage: viewModel.bgImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .scaleEffect(x: 1.3, y: 1.3)
                .blur(radius: 20)
                .brightness(-0.15)
        })
        .scrollIndicators(.hidden)
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

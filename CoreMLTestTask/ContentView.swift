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
    @ObservedObject var audioModel = AudioSettingsModel()
    
    var body: some View {
        LoadingView(isShowing: $viewModel.showLoadingView) {
            NavigationStack {
                ZStack {
                    VStack(alignment: .trailing) {
                        VStack(alignment: .leading) {
                            Text("Images")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.leading, 16)
                            TabView {
                                ForEach(viewModel.listItems, id: \.self) { element in
                                    
                                    Image(uiImage: element)
                                        .resizable()
                                        .cornerRadius(14)
                                        .scaledToFit()
                                        .frame(width: 280, height: 280 * commonImageRatio)
                                        .onAppear {
                                            withAnimation(.easeInOut) {
                                                viewModel.bgImage = element
                                            }
                                        }
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            
                            HStack {
                                Text("Music")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 16)
                                Button {
                                    if audioModel.playing {
                                        self.audioModel.pauseSound()
                                        audioModel.isPlaying = false
                                    } else {
                                        self.audioModel.playSound(sound: "music_full", type: "mp3")
                                        self.audioModel.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                        audioModel.isPlaying = true
                                    }
                                } label: {
                                    Image(systemName: !audioModel.isPlaying ? "play.circle" : "pause.circle")
                                        .foregroundColor(Color.white.opacity(0.8))
                                        .font(.system(size: 38))
                                }
                                Button(action: {
                                    self.audioModel.stopSound()
                                    self.audioModel.playValue = 0.0
                                    self.audioModel.isPlaying = false
                                }) {
                                    Image(systemName: "stop.circle")
                                        .font(.system(size: 38))
                                        .foregroundColor(Color.white.opacity(0.8))
                                }
                            }
                           
                            Slider(value: $audioModel.playValue, in: TimeInterval(0.0)...audioModel.playerDuration, onEditingChanged: { _ in
                                self.audioModel.changeSliderValue()
                            })
                            .onReceive(audioModel.timer) { _ in
                                if self.audioModel.playing {
                                    if let currentTime = self.audioModel.audioPlayer?.currentTime {
                                        self.audioModel.playValue = currentTime
                                        
                                        if currentTime == TimeInterval(0.0) {
                                            self.audioModel.playing = false
                                        }
                                    }
                                    
                                }
                                else {
                                    self.audioModel.playing = false
                                    self.audioModel.timer.upstream.connect().cancel()
                                }
                            }
                            .padding(.horizontal)
                            .frame(height: 50, alignment: .center)
                            
                        }
                        .padding(.bottom)
                        Button {
                            audioModel.stopSound()
                            audioModel.playValue = 0.0
                            audioModel.isPlaying = false
                            viewModel.showLoadingView = true
                            viewModel.generateVideo()
                        } label: {
                            Text("Apply effects >")
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding(.trailing)
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
                    .onAppear {
                        if !viewModel.viewDidLoad {
                            viewModel.onViewDidLoad()
                            viewModel.viewDidLoad = true
                        }
                    }
                    .navigationDestination(isPresented: $viewModel.isVideoGenerated) {
                        if let url = viewModel.videoURL {
                            let player = AVPlayer(url: url)
                            
                            VideoPlayer(player: player)
                                .background {
                                    Color.black
                                }
                                .onDisappear {
                                    viewModel.isVideoGenerated = false
                                }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

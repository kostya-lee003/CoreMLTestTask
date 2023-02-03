//
//  AudioPlayerView.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import AVKit
import SwiftUI

struct AudioPlayerView: View {
    
    @State var audioPlayer: AVAudioPlayer!
    @State var progress: CGFloat = 0.0
    @State private var playing: Bool = false
    @State var duration: Double = 0.0
    @State var formattedDuration: String = ""
    @State var formattedProgress: String = "00:00"
    
    var body: some View {
        HStack {
            Text(formattedProgress)
                .font(.caption.monospacedDigit())
                .foregroundColor(Color.white)

            // this is a dynamic length progress bar
            GeometryReader { gr in
                Capsule()
                    .stroke(Color.white.opacity(0.75), lineWidth: 1)
                    .background(
                        Capsule()
                            .foregroundColor(Color.blue.opacity(0.75))
                            .frame(width: gr.size.width * progress,
                                      height: 8), alignment: .leading)
            }
            .frame( height: 8)

            Text(formattedDuration)
                .font(.caption.monospacedDigit())
                .foregroundColor(Color.white)
        }
        
        .frame(height: 50, alignment: .center)
        
        
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            Button(action: {
                let decrease = self.audioPlayer.currentTime - 5
                if decrease < 0.0 {
                    self.audioPlayer.currentTime = 0.0
                } else {
                    self.audioPlayer.currentTime -= 5
                }
            }) {
                Image(systemName: "gobackward.5")
                    .font(.title)
                    .imageScale(.medium)
                    .foregroundColor(Color.blue.opacity(0.75))
            }

            Button(action: {
                if audioPlayer.isPlaying {
                    playing = false
                    self.audioPlayer.pause()
                } else if !audioPlayer.isPlaying {
                    playing = true
                    self.audioPlayer.play()
                }
            }) {
                Image(systemName: playing ?
                      "pause.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .imageScale(.large)
                    .foregroundColor(Color.blue.opacity(0.75))
            }

            Button(action: {
                let increase = self.audioPlayer.currentTime + 5
                if increase < self.audioPlayer.duration {
                    self.audioPlayer.currentTime = increase
                } else {
                    self.audioPlayer.currentTime = duration
                }
            }) {
                Image(systemName: "goforward.5")
                    .font(.title)
                    .imageScale(.medium)
                    .foregroundColor(Color.blue.opacity(0.65))
            }
            Spacer()
        }
        .onAppear {
            initialiseAudioPlayer()
        }
    }
    
    func initialiseAudioPlayer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        let path = Bundle.main.path(forResource: "music",
                                  ofType: "mp3")!
        self.audioPlayer = try! AVAudioPlayer(contentsOf:
                                  URL(fileURLWithPath: path))
        self.audioPlayer.prepareToPlay()
        formattedDuration = formatter.string(from:
                 TimeInterval(self.audioPlayer.duration))!
        duration = self.audioPlayer.duration

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !audioPlayer.isPlaying {
                playing = false
            }
            progress = CGFloat(audioPlayer.currentTime /
                                              audioPlayer.duration)
            formattedProgress = formatter.string(from: TimeInterval(self.audioPlayer.currentTime))!
        }
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView()
            .previewLayout(
                   PreviewLayout.fixed(width: 400, height: 300))
            .previewDisplayName("Default preview")
        AudioPlayerView()
            .previewLayout(
                    PreviewLayout.fixed(width: 400, height: 300))
            .environment(\.sizeCategory, .accessibilityExtraLarge)
    }
}

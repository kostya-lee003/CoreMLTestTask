//
//  Constants.swift
//  CoreMLTestTask
//
//  Created by Kostya Lee on 03/02/23.
//

import SwiftUI

// MARK: Images
let templateImageSet = [group, person_abandonedBuilding, skate, person_garage, person_walls, person_sky, person_roof]

let group = UIImage(named: "group")!
let person_abandonedBuilding = UIImage(named: "person_abandonedBuilding")!
let person_garage = UIImage(named: "person_garage")!
let person_jump = UIImage(named: "person_jump")!
let person_roof = UIImage(named: "person_roof")!
let person_sky = UIImage(named: "person_sky")!
let person_walls = UIImage(named: "person_walls")!
let skate = UIImage(named: "skate")!


let commonImageRatio = 289.7 / 200.0


// MARK: Strings

/// Alert error strings
let MissingResourceFiles = "Missing resource files"
let MissingImageFiles = "Missing image files"
let MissingAudioFiles = "Missing audio files"
let MissingVideoFiles = "Missing video files"

let FnishedMultipleVideoGeneration = "Finished multiple type video generation"
let FinishedSingleTypeVideoGeneration = "Finished single type video generation"
let FinishedMergingVideos = "Finished merging videos"
let FinishReversingVideo = "Finished reversing video"
let FinishSplittingVideo = "Finished splitting video"
let FinishMergingVideoWithAudio = "Finished merging video with audio"

let SingleMovieFileName = "singleMovie"
let MultipleMovieFileName = "multipleVideo"
let MultipleSingleMovieFileName = "newVideo"
let MergedMovieFileName = "mergedMovie"
let ReversedMovieFileName = "reversedMovie"
let SplitMovieFileName = "splitMovie"
let NewAudioMovieFileName = "newAudioMovie"

/// Resource extensions
let MovExtension = "mov"
let Mp3Extension = "mp3"
let MOVExtension = "mov"
let Mp4Extension = "mp4"

/// Resource file names
let Video1 = "video1"
let Video2 = "video2"
let Video3 = "video3"
let Video4 = "video4"
let PortraitVideo = "portraitVideo"

let Message = "message"
let OK = "OK"

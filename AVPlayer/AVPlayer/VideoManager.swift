//
//  VideoManager.swift
//  AVPlayer
//
//  Created by Kuangyu Nien on 2019/12/20.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit
import os
class VideoManager {
    
    static func testExportByAVAssetExportSession() {
        let saveVideoToPhotos: (_ outputURL: URL) -> Void  = {
            (outputURL: URL) -> Void in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)  }) {
                    success, error in
                    if success {
                        os_log("Succesfully Saved", type: .debug)
                    } else {
                        os_log("Export failed: %@", type: .error,error?.localizedDescription ?? "error")
                    }
            }
        }
        let url = Bundle.main.url(forResource: "test", withExtension: "mp4")
        let asset = AVAsset(url: url!)
                
        // Setup to use preferred background color
        let prototypeInstruction = AVMutableVideoCompositionInstruction()
        prototypeInstruction.backgroundColor = UIColor.red.cgColor
        let videoComposition = AVMutableVideoComposition(propertiesOf: asset, prototypeInstruction: prototypeInstruction)
        
        //Set frame renderSize & frame duration
        //        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        videoComposition.renderSize = CGSize(width: 400,height: 224)
        videoComposition.sourceTrackIDForFrameTiming = kCMPersistentTrackID_Invalid;
        videoComposition.frameDuration = CMTime(value: 1, timescale: 5)
        
        AVAssetExportSession.determineCompatibility(ofExportPreset: AVAssetExportPresetHighestQuality, with: asset, outputFileType: .mov) {
            compatible in
            if compatible {
                guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
                    print("Failed to create export session to AVC")
                    return
                }
                exportSession.videoComposition = videoComposition
                exportSession.outputFileType = AVFileType.mov //AVFileTypeQuickTimeMovie
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                       in: .userDomainMask).first else {
                                                                        return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .short
                let date = dateFormatter.string(from: Date())
                let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
                exportSession.outputURL = url
                //                let start: CMTime = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
                //                let duration: CMTime = CMTimeMakeWithSeconds(3.0, preferredTimescale: 600)
                //                let range: CMTimeRange = CMTimeRangeMake(start: start, duration: duration)
                //                exportSession.timeRange = range
                exportSession.exportAsynchronously { () -> Void in
                    // Handle export results.
                    switch exportSession.status {
                    case .completed:
                        os_log("Export completed", type: .debug)
                        // Ensure permission to access Photo Library
                        if PHPhotoLibrary.authorizationStatus() != .authorized {
                            PHPhotoLibrary.requestAuthorization({ status in
                                if status == .authorized {
                                    saveVideoToPhotos(exportSession.outputURL!)
                                }
                            })
                        } else {
                            saveVideoToPhotos(exportSession.outputURL!)
                        }
                        
                    case .failed:
                        os_log("Export failed: %@", type: .error, exportSession.error?.localizedDescription ?? "error")
                        break
                    case .cancelled:
                        os_log("Export canceled", type: .debug)
                        break
                    default:
                        break
                    }
                }
            } else {
                print("Export Session failed compatibility check")
            }
            
        }
    }
    
    static func getFPSUsingAsset(asset: AVURLAsset) {
        //Get FPS
        let tracks = asset.tracks(withMediaType: .video)
        let fps = tracks.first?.nominalFrameRate
        print("fps is: \(fps)")
    }

    static func getFPSWhenPlaying(player: AVPlayer) {
        if let currentItem = player.currentItem {
            for track in currentItem.tracks {
                if track.assetTrack?.mediaType  == AVMediaType.video {
                    print("fps is: \(track.currentVideoFrameRate)")
                }
            }
        }
    }
    
    
    //ref: https://gist.github.com/SheffieldKevin/6e9de245bc214d9be7c6
    static func printVideoInfo(url: URL) {
        let theOpts = [
            AVURLAssetPreferPreciseDurationAndTimingKey : true,
            AVURLAssetReferenceRestrictionsKey : 0 // AVAssetReferenceRestrictions.RestrictionForbidNone
            ] as [String : Any]
        let movie = AVURLAsset(url:url, options:theOpts)
        print("We have a movie")
        print("==============================")
        print("Getting the total number of tracks:")
        print("Movie has \(movie.tracks.count) tracks")
        print("==============================")
        print("Getting the number of tracks based on their characteristics")
        print("Movie has \(movie.tracks(withMediaCharacteristic: AVMediaCharacteristic.visual).count) visual tracks")
        print("Movie has \(movie.tracks(withMediaCharacteristic: AVMediaCharacteristic.audible).count) audible tracks")
        print("==============================")
        print("Getting the number of tracks based on their mediaType")
        print("Movie has \(movie.tracks(withMediaType: AVMediaType.video).count) video tracks")
        print("Movie has \(movie.tracks(withMediaType: AVMediaType.audio).count) audio tracks")
        print("==============================")
        print("Now getting the CMPersistentTrackID for each track")
        var trackID:CMPersistentTrackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)
        
        for (index, track) in movie.tracks.enumerated() {
            trackID = track.trackID
            print("Track at index: \(index) has track ID: \(trackID)")
        }
        print("==============================")
        print("Now get the track with the last track ID")
        let track:AVAssetTrack? = movie.track(withTrackID: trackID) ?? nil
        print("Track with trackID: \(trackID) is: \(String(describing: track))")
        print()
        print("==============================")
        print("Lets get the track segments of one of the last track")
        if let segments = track?.segments {
            for (index, segment) in segments.enumerated() {
                let sourceRange = CMTimeRangeCopyAsDictionary(segment.timeMapping.source, allocator: kCFAllocatorDefault)
                print("Segment \(index) time range for source: \(String(describing: sourceRange))")
                let targetRange = CMTimeRangeCopyAsDictionary(segment.timeMapping.target, allocator: kCFAllocatorDefault)
                print("Segment \(index) time range for target: \(String(describing: targetRange))")
            }
        }
        
    }
}

extension VideoManager {
    private func setupCustomPlayByLocalFile(url: URL) {
        /*
        let theOpts = [
            AVURLAssetPreferPreciseDurationAndTimingKey : true,
            AVURLAssetReferenceRestrictionsKey : 0 // AVAssetReferenceRestrictions.RestrictionForbidNone
            ] as [String : Any]
        let asset = AVURLAsset(url: url, options: theOpts)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        */
    }
}

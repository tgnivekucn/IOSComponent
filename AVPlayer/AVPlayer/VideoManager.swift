//
//  VideoManager.swift
//  AVPlayer
//
//  Created by Kuangyu Nien on 2019/12/20.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import Foundation
import AVFoundation
class VideoManager {
    
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

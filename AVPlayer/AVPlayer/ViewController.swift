//
//  ViewController.swift
//  AVPlayer
//
//  Created by Kuangyu Nien on 2019/12/18.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import os.log
import Photos
class ViewController: UIViewController {
    
    var asset: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var queuepPlayer: AVQueuePlayer!
    var playerLayer: AVPlayerLayer!
    
    
    let url = Bundle.main.url(forResource: "test", withExtension: "mp4")
    let url2 = Bundle.main.url(forResource: "test2", withExtension: "mp4")
    
    private var kvoContext = 0
    private var kvoContext2 = 1
    private var timeObserverToken: Any? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupCustomPlayer()
        //
        
        //        setupQueuePlayer()
        //        startDemoVideo(videoURL: url2!)
        
        //        setupAVPlayer()
        //        setupAVPlayer(videoURL: url2!)
//        if let url = Bundle.main.url(forResource: "test2", withExtension: "mp4") {
//            setupCustomPlayByLocalFile(url: url)
//            VideoManager.printVideoInfo(url: url)
//            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &kvoContext)
//        }
        
        test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        addPeriodicTimeObserver()
//        NotificationCenter.default.addObserver(self,
//                                                 selector: #selector(playerItemDidPlayToEnd),
//                                                 name: .AVPlayerItemDidPlayToEndTime,
//                                                 object: player?.currentItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func playerItemDidPlayToEnd() {
        print("playerItemDidPlayToEnd")
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        if context == &kvoContext {
            if let item = object as? AVPlayerItem {
            switch keyPath {
            case #keyPath(AVPlayerItem.status):
                if item.status == .readyToPlay {
                    print("test readyToPlay ")
                }
                if item.status == .unknown {
                    print("test unknown ")
                }
                if item.status == .failed {
                    print("test failed ")
                }
                break
            case #keyPath(AVPlayerItem.loadedTimeRanges):
                for range in item.loadedTimeRanges {
                    print(range.timeRangeValue)
                }
                break
            default:
                break
                }
            }
        }
    }
    
    
    func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 1,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Add time observer. Invoke closure on the main queue.
        timeObserverToken =
            player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
                [weak self] time in
                // update player transport UI
                print("current player time is: \(String(describing: self?.player.currentTime()))")
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
        }
    }
    
    deinit {
        print("ViewController deinit")
    }
    
    @IBAction func pressBtnAction(_ sender: UIButton) {
        playVideo()
    }
    @IBAction func backwardAction(_ sender: UIButton) {
        
    }
    
    @IBAction func playAndPause(_ sender: UIButton) {
        player?.play()
        
        //        player?.pause()
        
    }
    
    @IBAction func forwardAction(_ sender: UIButton) {
    }
    
    @IBAction func stopAction(_ sender: UIButton) {
        player?.pause()
    }
    
    private func playVideo() {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    
    private func setupCustomPlayer() {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {
            return
        }
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
    }
    
    // AVAsset -  AVPlayerItem - AVPlayerItemTrack(video, audio,...)
    // AVMutableComposition ( CompositionPlayerItemTrack(video,audio)  )
    //    - AVMutableAudioMix
    //    - AVMutableVideoComposition (AVMutableVideoCompositionInstruction)
    private func setupCustomPlayByLocalFile(url: URL) {
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
    }
    
    /*
     ["AVAssetExportPreset1920x1080", "AVAssetExportPresetLowQuality", "AVAssetExportPresetHEVC1920x1080WithAlpha", "AVAssetExportPresetAppleM4A", "AVAssetExportPresetHEVCHighestQuality", "AVAssetExportPreset640x480", "AVAssetExportPreset3840x2160", "AVAssetExportPresetHEVC3840x2160WithAlpha", "AVAssetExportPresetHEVC3840x2160", "AVAssetExportPresetHighestQuality", "AVAssetExportPreset1280x720", "AVAssetExportPresetMediumQuality", "AVAssetExportPreset960x540", "AVAssetExportPresetHEVCHighestQualityWithAlpha", "AVAssetExportPresetHEVC1920x1080"]

     */
    func test() {
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
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
        if compatiblePresets.contains("AVAssetExportPresetLowQuality") {
            if let exportSession = AVAssetExportSession(asset: asset, presetName: "AVAssetExportPresetLowQuality") {
                exportSession.outputFileType = AVFileType.mov //AVFileTypeQuickTimeMovie
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                       in: .userDomainMask).first else {
                  return
                }
                let url = documentDirectory.appendingPathComponent("MyOutput1.mov")
                exportSession.outputURL = url
                let start: CMTime = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
                let duration: CMTime = CMTimeMakeWithSeconds(3.0, preferredTimescale: 600)
                let range: CMTimeRange = CMTimeRangeMake(start: start, duration: duration)
                exportSession.timeRange = range
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
            }
        }

        
    
        
        /*
         exportSession.outputURL = A file URL;
           exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
           CMTime start = CMTimeMakeWithSeconds(1.0, 600);
           CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
           CMTimeRange range = CMTimeRangeMake(start, duration);
           exportSession.timeRange = range;

           [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
               switch ([exportSession status]) {
                   case AVAssetExportSessionStatusFailed:
                       NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                       break;
                   case AVAssetExportSessionStatusCancelled:
                       NSLog(@"Export canceled");
                       break;
                   default:
                       break;
               }
           }];
        */
        
//        let url = Bundle.main.url(forResource: "test", withExtension: "mp4")//A URL that identifies an audiovisual asset such as a movie file
//        let asset = AVURLAsset(url: url!, options: nil)
//
        
//        NSURL *url = A URL that identifies an audiovisual asset such as a movie file;
//        NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
//        AVURLAsset *anAssetToUseInAComposition = [[AVURLAsset alloc] initWithURL:url options:options];

//        let url = Bundle.main.url(forResource: "test", withExtension: "mp4")//A URL that identifies an audiovisual asset such as a movie file;
//        let theOpts: [String : Any] = [AVURLAssetPreferPreciseDurationAndTimingKey : true]
//        let anAssetToUseInAComposition = AVURLAsset(url: url!, options: theOpts)
        
        
        
//        // URL of a bundle asset called 'example.mp4'
//        let url = Bundle.main.url(forResource: "example", withExtension: "mp4")
//        let asset = AVAsset(url: url!)
//        let durationKey = "duration"
//
//        // Load the "playable" property
//        asset.loadValuesAsynchronously(forKeys: [durationKey]) {
//            var error: NSError? = nil
//            let status = asset.statusOfValue(forKey: durationKey, error: &error)
//            switch status {
//            case .loaded:
//                // Sucessfully loaded. Continue processing.
//                break
//            case .failed:
//                // Handle error
//                break
//            case .cancelled:
//                // Terminate processing
//                break
//            default:
//                // Handle all other cases
//                break
//            }
//        }
        /*
        let url = Bundle.main.url(forResource: "example", withExtension: "mp4")
        let anAsset = AVAsset(url: url!)
        let outputURL = "未完成"// URL of your exported output //
         
        // These settings will encode using H.264.
        let preset = AVAssetExportPresetHighestQuality
        let outFileType = AVFileTypeQuickTimeMovie

        AVAssetExportSession.determineCompatibility(ofExportPreset: preset, with: anAsset, outputFileType: outFileType, completionHandler: { (isCompatible) in
            if !isCompatible {
                return
        }})

        guard let export = AVAssetExportSession(asset: anAsset, presetName: preset) else {
            return
        }

        export.outputFileType = outFileType
        export.outputURL = outputURL
        export.exportAsynchronously { () -> Void in
           // Handle export results.
        }
        */

    }
    func setupAVPlayer() {
        player = AVPlayer()
    }
    func setupAVPlayer(videoURL: URL) {
        let videoAsset = AVURLAsset(url: videoURL)
        videoAsset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
            DispatchQueue.main.async {
                let item = AVPlayerItem(asset: videoAsset)
                self.player = AVPlayer(playerItem: item)
                
                //add playerLayer to View
                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.frame = self.view.bounds
                self.view.layer.addSublayer(playerLayer)
                
                self.player?.play()
            }
        }
    }
    
    
    func setupQueuePlayer() {
        queuepPlayer = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else { fatalError("Error creating player layer") }
        playerLayer.frame = view.layer.bounds
        view.layer.addSublayer(playerLayer)
    }
    
    func startDemoVideo(videoURL: URL) {
        let videoAsset = AVURLAsset(url: videoURL)
        videoAsset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
            DispatchQueue.main.async {
                let loopItem = AVPlayerItem(asset: videoAsset)
                self.queuepPlayer?.insert(loopItem, after: nil)
                self.queuepPlayer?.play()
            }
        }
    }
}


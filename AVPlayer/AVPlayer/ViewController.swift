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
class ViewController: UIViewController {
    
    var asset: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var queuepPlayer: AVQueuePlayer!
    var playerLayer: AVPlayerLayer!
    
    
    let url = Bundle.main.url(forResource: "test", withExtension: "mp4")
    let url2 = Bundle.main.url(forResource: "test2", withExtension: "mp4")
    
    private var kvoContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupCustomPlayer()
        //
        
        //        setupQueuePlayer()
        //        startDemoVideo(videoURL: url2!)
        
        //        setupAVPlayer()
        //        setupAVPlayer(videoURL: url2!)
        if let url = Bundle.main.url(forResource: "test", withExtension: "mp4") {
            setupCustomPlayByLocalFile(url: url)
            VideoManager.printVideoInfo(url: url)
            
            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &kvoContext)

//            if let item = newValue.currentItem {
//                    item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: &kvoContext)
//                    item.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: &kvoContext)            }
//
//                let timeInterval = CMTime(value: 1, timescale: 2)
//                self.timeObserverToken = newValue.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (time: CMTime) in
//                    print(time)
//                    self.updatePositionSlider()
//                })
            
            
        }
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


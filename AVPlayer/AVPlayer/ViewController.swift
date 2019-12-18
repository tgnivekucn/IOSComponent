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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressBtnAction(_ sender: UIButton) {
        playVideo()
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
}


//
//  PlayViewController.swift
//  MediaAppWithRotation
//
//  Created by Khusboo Suhasini Preety on 11/09/19.
//  Copyright © 2019 Khusboo Suhasini Preety. All rights reserved.
//

import UIKit
import AVKit


class PlayViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var localPath:String = ""
    var player:AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if localPath.contains(".mp4"){
            playVideo(from: localPath)
        }else{
           
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if player != nil {
            player?.pause()
            player=nil
        }
    }
    private func playVideo(from filePath:String) {
        
        player = AVPlayer(url: URL(fileURLWithPath: filePath))
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player?.play()
    }


}


//
//  ViewController.swift
//  DemoFFMEG
//
//  Created by mac on 14.01.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer = AVQueuePlayer(items: [])
    
    var asset: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    
    private var playerItemContext = 0
    
    private var FFMPEG_RESTREAM_ADDRESS = "http://localhost:1234/restream.wav"
   
    private let FFMPEG_COMMAND_TEMPLATE = "-i \"%@\" -vn -strict -2 -acodec pcm_u8 -f wav -listen 1 -seekable 1 %@"
    // comand template for ffmpeg

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func startPlay(_ sender: UIButton) {
        MobileFFmpegConfig.setLogDelegate(self)
        let stringPath = Bundle.main.path(forResource: "Daft Punk - Get Lucky (Joe Maz Remix) (Extended)", ofType: "mp3")! // gettint path to input file
        let command = String(format: FFMPEG_COMMAND_TEMPLATE, stringPath, FFMPEG_RESTREAM_ADDRESS) //create a command
        _ = MobileFFmpeg.executeAsync(command, withCallback: self) // execute a command
    }
}



extension ViewController: ExecuteDelegate, LogDelegate {
    
    func executeCallback(_ executionId: Int, _ returnCode: Int32) {
        print(executionId)
        print(returnCode)
    }
    
    // here we get logs from ffmpeg and check Input #0, if it is we can start working with FFMPEG_RESTREAM_ADDRESS
    func logCallback(_ executionId: Int, _ level: Int32, _ message: String!) {
        print("!" + message)
        if message.range(of: "Input #0") != nil {
            let url = URL(string: FFMPEG_RESTREAM_ADDRESS)!
            asset = AVAsset(url: url)
            
            // Create a new AVPlayerItem with the asset and an
            playerItem = AVPlayerItem(asset: asset)
            
            // Register as an observer of the player item's status property
            playerItem.addObserver(self,
                                   forKeyPath: #keyPath(AVPlayerItem.status),
                                   options: [.old, .new],
                                   context: &playerItemContext)
            
            // Associate the player item with the player
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                print("????READY TO PLAY")
                player.play()
            case .failed:
                print("????FAILED")
                print("????")
                print(playerItem.error ?? "")
            case .unknown:
                print("????unknown")
            @unknown default:
                break
            }
        }
    }
}



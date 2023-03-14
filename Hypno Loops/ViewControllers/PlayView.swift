//
//  LoopPlayViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation

class PlayView: UIViewController {
    let reverb = AVAudioUnitReverb()
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupAudio() {
        audioEngine.attach(reverb)
        audioEngine.connect(playerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        do {
            try audioEngine.start()
            playerNode.play()
        } catch {
            
        }
    }

}




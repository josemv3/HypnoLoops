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

    @IBOutlet weak var soundscapesButton: UIButton!
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
    
    func presentModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let audioView = storyboard.instantiateViewController(withIdentifier: "AudioView") as? AudioView {
            
            let nav = UINavigationController(rootViewController: audioView)
            nav.modalPresentationStyle = .pageSheet
            
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .large
                //allows scrolling in AudioView
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                sheet.prefersGrabberVisible = true
            }
            present(nav, animated: true, completion: nil)
        }
    }

    @IBAction func soundscapesButtonPressed(_ sender: Any) {
        presentModal()
    }
}




//
//  LoopPlayViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation

class PlayView: UIViewController {
    
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var soundScapeButton: UIButton!
    @IBOutlet weak var soundScapeLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var playButtonBG: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    let reverb = AVAudioUnitReverb()
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundScapeButton.tintColor = UIColor(named: Color.hlBlue.rawValue)
        recordingButton.tintColor = UIColor(named: Color.hlBlue.rawValue)
        playButton.tintColor = UIColor(named: Color.hlBlue.rawValue)
        playButtonBG.layer.cornerRadius = CornerRadiusModifiers.normal.size
        playButtonBG.layer.borderWidth = BorderSize.small.size
        playButtonBG.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
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
    
    @IBAction func soundScapeButtonPushed(_ sender: Any) {
        presentModal()
    }
    
    @IBAction func recordingButtonPushed(_ sender: UIButton) {
    }
    
    @IBAction func settingsButtonPushed(_ sender: UIButton) {
    }
    
    @IBAction func replayButtonPressed(_ sender: UIButton) {
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
    
}




//
//  LoopRecordViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation

class LoopRecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var affirmationNameLabel: UILabel!
    @IBOutlet weak var affirmationNameTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var micBackgroundView: UIView!
    @IBOutlet weak var micImageView: UIImageView!
    
    @IBOutlet weak var recordButtonView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var reverbButtonView: UIView!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var compressionSlider: UISlider!
    
    @IBOutlet weak var saveButtton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession?
    var audioPlayer: AVAudioPlayer?
    
    var cornerRadiusModifier: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        micBackgroundView.layer.cornerRadius = cornerRadiusModifier
        recordButtonView.layer.cornerRadius = cornerRadiusModifier
        reverbButtonView.layer.cornerRadius = cornerRadiusModifier
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        let audioFileName = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        do {
            
            let audioEngine = AVAudioEngine()
            let audioPlayerNode = AVAudioPlayerNode()
            let reverb = AVAudioUnitReverb()
            reverb.loadFactoryPreset(.cathedral)
            reverb.wetDryMix = 50
            audioEngine.attach(audioPlayerNode)
            audioEngine.attach(reverb)
            audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
            audioEngine.connect(reverb, to: audioEngine.mainMixerNode, format: nil)
            audioEngine.prepare()
            try! audioEngine.start()
            audioPlayerNode.play()
            
//            audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
//            audioPlayer?.play()
            
            
        } catch {
//            handle failure to play recording
        }
        
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard let affirmationName = affirmationNameTextField.text, !affirmationName.isEmpty, let category = categoryTextField.text, !category.isEmpty else {
//            show error message
            return
        }
        
//        save recording
        
    }
    
    
    
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            recordButton.setTitle("Finish Recording", for: .normal)
            playButton.isEnabled = false
            
        } catch {
            
        }
        
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Start Recording", for: .normal)
            playButton.isEnabled = true
        } else {
            recordButton.setTitle("Start Recording", for: .normal)
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

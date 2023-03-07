//
//  LoopRecordViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation

class LoopRecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var affirmationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
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
    var recordingSession = AVAudioSession.sharedInstance()
    var audioPlayer: AVAudioPlayer?
    
    var isRecording = false
    var isPlaying = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        micBackgroundView.layer.cornerRadius = CornerRadiusModifiers.normal.size
        micBackgroundView.layer.borderWidth = BorderSize.small.size
        micBackgroundView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        recordButtonView.layer.cornerRadius = CornerRadiusModifiers.normal.size
        recordButtonView.layer.borderWidth = BorderSize.small.size
        recordButtonView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        reverbButtonView.layer.cornerRadius = CornerRadiusModifiers.normal.size
        reverbButtonView.layer.borderWidth = BorderSize.small.size
        reverbButtonView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        saveButtton.tintColor = UIColor(named: Color.hlBlue.rawValue)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isRecording {
            startRecording()
            isRecording.toggle()
            playButton.isEnabled = false
            let stopImage = UIImage(systemName: "stop.circle.fill")
            recordButton.setImage(stopImage, for: .normal)
        } else {
            finishRecording(success: true)
            isRecording.toggle()
            playButton.isEnabled = true
            let recordImage = UIImage(systemName: "record.circle")
            recordButton.setImage(recordImage, for: .normal)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isPlaying {
            isPlaying.toggle()
            recordButton.isEnabled = false
            let stopImage = UIImage(systemName: "stop.circle.fill")
            playButton.setImage(stopImage, for: .normal)
            startPlaying()
        } else {
            isPlaying.toggle()
            recordButton.isEnabled = false
            let playImage = UIImage(systemName: "play.fill")
            playButton.setImage(playImage, for: .normal)
            finishPlaying()
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
//AffirmationView-Update
//        guard let affirmationName = affirmationNameTextField.text, !affirmationName.isEmpty, let category = categoryTextField.text, !category.isEmpty else {
////            show error message
//            return
//        }

        
   //main
        
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
            try recordingSession.setCategory(.playAndRecord)
            try recordingSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
        } else {
            recordButton.setTitle("Record", for: .normal)
        }
    }
    
    func startPlaying()  {
            
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
                
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
                audioPlayer?.play()
                
                let stopImage = UIImage(systemName: "stop.circle.fill")
                playButton.setImage(stopImage, for: .normal)
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    
    func finishPlaying() {
        audioPlayer?.stop()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

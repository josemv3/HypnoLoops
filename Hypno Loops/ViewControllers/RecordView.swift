//
//  LoopRecordViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation

class RecordView: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
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
    
    var recorder    : AVAudioRecorder?
    var playerNode  : AVAudioPlayerNode?
    
    var isRecording = false
    var isPlaying   = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
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
        
        affirmationLabel.layer.borderWidth = BorderSize.small.size
        affirmationLabel.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
    }
    
//    MARK: - Recording
    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true)
            
            let audioURL = getDocumentsDirectory().appendingPathExtension("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder?.delegate = self
            recorder?.record()
            isRecording = true
            recordButton.setTitle("Stop", for: .normal)
            let stopImage = UIImage(systemName: "stop.fill")
            recordButton.setImage(stopImage, for: .normal)
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        recorder?.stop()
        isRecording = false
        let recordImage = UIImage(systemName: "circle.fill")
        recordButton.setImage(recordImage, for: .normal)
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
//    MARK: - Playing
    
    func startPlayback() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setActive(true)
//            let playBackURL = getDocumentsDirectory().appendingPathExtension("recording.m4a")
//            let audioFile = try AVAudioFile(forReading: playBackURL)
//            let audioEngine = AVAudioEngine()
//            let playerNode = AVAudioPlayerNode()
//            audioEngine.attach(playerNode)
//            let reverb = AVAudioUnitReverb()
//            reverb.loadFactoryPreset(.cathedral)
//            reverb.wetDryMix = 50
//            audioEngine.attach(reverb)
//            audioEngine.connect(playerNode, to: reverb, format: audioFile.processingFormat)
//            audioEngine.connect(reverb, to: playerNode, format: audioFile.processingFormat)
//            playerNode.scheduleFile(audioFile, at: nil)
//            playerNode.play()
//            isPlaying = true
//            playButton.setTitle("Stop", for: .normal)
//            let stopImage = UIImage(systemName: "stop.fill")
//            playButton.setImage(stopImage, for: .normal)
//            self.playerNode = playerNode
//        } catch {
//            print("Error: \(error.localizedDescription)")
//        }
        let audioSession = AVAudioSession.sharedInstance()
          do {
              try audioSession.setCategory(.playback)
              try audioSession.setActive(true)
              
              let playBackURL = getDocumentsDirectory().appendingPathExtension("recording.m4a")
              let audioFile = try AVAudioFile(forReading: playBackURL)
              
              if audioFile.length == 0 {
                  print("Error: audio file contains no audio data")
                  return
              }
              
              let audioEngine = AVAudioEngine()
              let playerNode = AVAudioPlayerNode()
              audioEngine.attach(playerNode)
              let reverb = AVAudioUnitReverb()
              reverb.loadFactoryPreset(.cathedral)
              reverb.wetDryMix = 50
              audioEngine.attach(reverb)
              audioEngine.connect(playerNode, to: reverb, format: audioFile.processingFormat)
              audioEngine.connect(reverb, to: playerNode, format: audioFile.processingFormat)
              playerNode.scheduleFile(audioFile, at: nil)
              try audioEngine.start()
              playerNode.play()
              isPlaying = true
              playButton.setTitle("Stop", for: .normal)
              let stopImage = UIImage(systemName: "stop.fill")
              playButton.setImage(stopImage, for: .normal)
              self.playerNode = playerNode
          } catch {
              print("Error: \(error.localizedDescription)")
          }
    }
    
    func stopPlayback() {
        playerNode?.stop()
        isPlaying = false
        let playImage = UIImage(systemName: "play.fill")
        playButton.setImage(playImage, for: .normal)
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isPlaying {
            startPlayback()
        } else {
            stopPlayback()
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

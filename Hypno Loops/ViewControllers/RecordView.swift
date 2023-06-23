//
//  LoopRecordViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation

class RecordView: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var micBackgroundView: UIView!
    @IBOutlet weak var micImageView: UIImageView!
    
    @IBOutlet weak var affirmationView: UIView!
    @IBOutlet weak var affirmationLabel: UILabel!
    
    @IBOutlet weak var recordButtonView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var reverbButtonView: UIView!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var compressionSlider: UISlider!
    @IBOutlet weak var saveButtton: UIButton!
    
//    var audioRecorder = HypnoAudioRecorder()
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var audioPlayer = AudioPlayer()
    var url = URL(string: "")
    
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
        
        //categoryLabel.layer.borderWidth = BorderSize.small.size
        //categoryLabel.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        affirmationView.layer.cornerRadius = CornerRadiusModifiers.normal.size
        affirmationView.layer.borderWidth = BorderSize.small.size
        affirmationView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
    }
    
//    MARK: - Record
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isRecording {
            isRecording = true
            startRecording()
            playButton.isEnabled = false
            let stopImage = UIImage(systemName: "stop.fill")
            recordButton.setTitle("Stop", for: .normal)
            recordButton.setImage(stopImage, for: .normal)
            micImageView.tintColor = .red
        } else {
            isRecording = false
            audioRecorder.stop()
            playButton.isEnabled = true
            let recordImage = UIImage(systemName: "record.circle")
            recordButton.setTitle("Record", for: .normal)
            recordButton.setImage(recordImage, for: .normal)
            micImageView.tintColor = UIColor(named: Color.hlIndigo.rawValue)
        }
//        if !isRecording {
//            isRecording.toggle()
//            playButton.isEnabled = false
//            audioRecorder.startRecording()
//            let stopImage = UIImage(systemName: "stop.fill")
//            recordButton.setTitle("Stop", for: .normal)
//            recordButton.setImage(stopImage, for: .normal)
//            micImageView.tintColor = .red
//        } else {
//            isRecording.toggle()
//            url = audioRecorder.getAudioURL()
//            playButton.isEnabled = true
//            audioRecorder.stopRecording()
//            promptFileName()
//            let recordImage = UIImage(systemName: "record.circle")
//            recordButton.setTitle("Record", for: .normal)
//            recordButton.setImage(recordImage, for: .normal)
//            micImageView.tintColor = UIColor(named: Color.hlIndigo.rawValue)
//        }
    }
    
//    MARK: - Audio Functionality
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isPlaying {
            isPlaying.toggle()
            recordButton.isEnabled = false
            audioPlayer.playAudio(audioURL: getDocumentsDirectory())
            let stopImage = UIImage(systemName: "stop.fill")
            playButton.setTitle("Stop", for: .normal)
            playButton.setImage(stopImage, for: .normal)
        } else {
            isPlaying.toggle()
            audioPlayer.stopAudio()
            recordButton.isEnabled = true
            let playImage = UIImage(systemName: "play.fill")
            playButton.setTitle("Play", for: .normal)
            playButton.setImage(playImage, for: .normal)
        }
    }
    
    func startRecording() {
        let audioFileName = getDocumentsDirectory()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioSession.requestRecordPermission { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    
                    
                    audioRecorder.record()
                    
                } else {
                    let alertController = UIAlertController(title: "Permission Denied",
                                                            message: "Please grant permission to record audio in your device settings.",
                                                            preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(settingsAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.recordButton.isEnabled = false
                }
                
            }
        } catch {
            
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("recording.m4a")
        print("PATH IS HERE --->", path)
        return path
    }
    
//    func promptFileName() {
//        let url = audioRecorder.getAudioURL()
//        let alertController = UIAlertController(title: "Name your affirmation", message: nil, preferredStyle: .alert)
//        alertController.addTextField(configurationHandler: nil)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let renameAction = UIAlertAction(title: "Save", style: .default) { _ in
//            guard let newName = alertController.textFields?.first?.text else { return }
//            let newURL = url.deletingLastPathComponent().appendingPathComponent(newName)
//            do {
//                try FileManager.default.moveItem(at: url, to: newURL)
//                print("File renamed to \(newName)")
//            } catch {
//                print("Error renaming file: \(error.localizedDescription)")
//            }
//        }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(renameAction)
//
//        present(alertController, animated: true)
//    }

    
    @IBAction func reverbChanged(_ sender: UISlider) {
        audioPlayer.reverb?.wetDryMix = sender.value
    }
    
    
    @IBAction func compressonChanged(_ sender: UISlider) {
        //audioPlayer.compressionNode.wetDryMix = sender.value
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueID.gotoPlay.rawValue, sender: self)
    }
    
}

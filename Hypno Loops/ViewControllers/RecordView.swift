//
//  LoopRecordViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit
import AVFoundation
import DSWaveformImageViews

class RecordView: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var micBackgroundView: UIView!
    
    @IBOutlet weak var affirmationView: UIView!
    @IBOutlet weak var affirmationLabel: UILabel!
    
    @IBOutlet weak var recordButtonView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var reverbButtonView: UIView!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var compressionSlider: UISlider!
    @IBOutlet weak var saveButtton: UIButton!
    
    let waveFormView = WaveformLiveView()
    var timer: Timer?
    
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var audioPlayer = HypnoAudioPlayer()
    var currentAudioFileName: URL?
    var isRecording = false
    var isPlaying   = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupWaveform()
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
    
    func setupWaveform() {
        micBackgroundView.addSubview(waveFormView)
        waveFormView.frame = micBackgroundView.bounds
        waveFormView.shouldDrawSilencePadding = true
        waveFormView.configuration = waveFormView.configuration.with(style: .striped(.init(color: .blue)))
//        waveformLiveView.backgroundColor = .red
    }
    
    //    MARK: - Record
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    //    MARK: - Audio Functionality
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isPlaying {
            startPlaying()
        } else {
            stopPlaying()
        }
    }
    
    func startRecording() {
        createAudioFileURL()
        waveFormView.reset()

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            audioRecorder = try AVAudioRecorder(url: currentAudioFileName!, settings: settings)
            audioRecorder.isMeteringEnabled = true
            
            if getRecordingPermissions() {
                isRecording = true
                audioRecorder.record()
                timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
                updateRecordButtonUI()
            }
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    @objc func updateMeters() {
        audioRecorder.updateMeters()
        let currentAmplitude = 1 - pow(10, audioRecorder.averagePower(forChannel: 0) / 160)
//        waveformLiveView.add(sample: 1)
        print("AMP: ",currentAmplitude)
        waveFormView.add(sample: currentAmplitude)
    }
    
    func stopRecording() {
        timer?.invalidate()
        timer = nil
        isRecording = false
        audioRecorder.stop()
        audioRecorder = nil
        updateRecordButtonUI()
    }
    
    func getRecordingPermissions() -> Bool {
        var hasPermission = false
        audioSession.requestRecordPermission { [weak self] granted in
            guard let self = self else { return }
            if !granted {
                
                let alertController = UIAlertController(title: "Permission Denied", message: "Please grant permission to record audio in your device settings.", preferredStyle: .alert)
                
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
            hasPermission = granted
        }
        return hasPermission
    }
    
    func startPlaying() {
        isPlaying = true
        audioPlayer.playAudio(audioURL: currentAudioFileName!)
        updatePlayButtonUI()
    }
    
    func stopPlaying() {
        isPlaying = false
        audioPlayer.stopAudio()
        updatePlayButtonUI()
    }
    
    func createAudioFileURL() {
        currentAudioFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(generateUniqueName())
    }
    
    func updateRecordButtonUI() {
        if isRecording {
            playButton.isEnabled = false
            let stopImage = UIImage(systemName: "stop.fill")
            recordButton.setTitle("Stop", for: .normal)
            recordButton.setImage(stopImage, for: .normal)
        } else {
            playButton.isEnabled = true
            let recordImage = UIImage(systemName: "record.circle")
            recordButton.setTitle("Record", for: .normal)
            recordButton.setImage(recordImage, for: .normal)
        }
    }
    
    func updatePlayButtonUI() {
        if isPlaying {
            recordButton.isEnabled = false
            let stopImage = UIImage(systemName: "stop.fill")
            playButton.setTitle("Stop", for: .normal)
            playButton.setImage(stopImage, for: .normal)
        } else {
            recordButton.isEnabled = true
            let playImage = UIImage(systemName: "play.fill")
            playButton.setTitle("Play", for: .normal)
            playButton.setImage(playImage, for: .normal)
        }
    }
    
    func generateUniqueName() -> String {
        let uuid = UUID().uuidString
        let uniqueString = "\(uuid).m4a"
        return uniqueString
    }
    
    func generateRandomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charCount = characters.count
        var randomString = ""

        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<charCount)
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }

        return randomString
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
//        audioPlayer.compressionNode.wetDryMix = sender.value
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueID.gotoPlay.rawValue, sender: self)
    }
}

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
    
    @IBOutlet weak var affirmationView: UIView!
    @IBOutlet weak var affirmationLabel: UILabel!
    
    @IBOutlet weak var recordButtonView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var reverbButtonView: UIView!
    @IBOutlet weak var reverbSlider: UISlider!
    @IBOutlet weak var compressionSlider: UISlider!
    @IBOutlet weak var saveButtton: UIButton!
    @IBOutlet weak var visualizerView: PulsatingCircleView!
    
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
        currentAudioFileName = createAudioFileURL()
        print("MC BOUNDS: ", micBackgroundView.bounds)
    }
    
    func setupViews() {
        micBackgroundView.layer.cornerRadius = CornerRadiusModifiers.normal.size
//        micBackgroundView.layer.borderWidth = BorderSize.small.size
//        micBackgroundView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
//        
        recordButtonView.layer.cornerRadius = CornerRadiusModifiers.normal.size
//        recordButtonView.layer.borderWidth = BorderSize.small.size
//        recordButtonView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
//        
        reverbButtonView.layer.cornerRadius = CornerRadiusModifiers.normal.size
//        reverbButtonView.layer.borderWidth = BorderSize.small.size
//        reverbButtonView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
//        
        saveButtton.tintColor = UIColor(named: Color.hlBlue.rawValue)
        
        //categoryLabel.layer.borderWidth = BorderSize.small.size
        //categoryLabel.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        affirmationView.layer.cornerRadius = CornerRadiusModifiers.normal.size
//        affirmationView.layer.borderWidth = BorderSize.small.size
//        affirmationView.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
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
                updateRecordButtonUI()
                
                startAudioLevelMonitoring()
            }
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        isRecording = false
        audioRecorder.stop()
        audioRecorder = nil
        updateRecordButtonUI()

        visualizerView.updatePulse(with: 0)
        timer?.invalidate()
        timer = nil
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
    
//    func changeAudioFileName() -> URL {
//        let alertController = UIAlertController(title: "Name Your Soundscape", message: nil, preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "Soundscape Name"
//        }
//
//        let okAction = UIAlertAction(title: "OK", style: .default)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        [okAction, cancelAction].forEach { alertController.addAction($0) }
//        self.present(alertController, animated: true)
//
//        guard let textField = alertController.textFields?.first else { return URL(fileURLWithPath: "") }
//
//        let newFileName = textField.text
//
//
//        return URL(fileURLWithPath: "")
//    }

//    func promptForTextInput(completion: @escaping (String?) -> Void) {
//        let alertController = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "Text"
//        }
//
//        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
//            guard let textField = alertController.textFields?.first else {
//                completion(nil)
//                return
//            }
//            completion(textField.text)
//        }
//        alertController.addAction(okAction)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            completion(nil)
//        }
//        alertController.addAction(cancelAction)
//
//        guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else {
//            completion(nil)
//            return
//        }
//
//        topViewController.present(alertController, animated: true, completion: nil)
//    }

    // Usage Example
//    promptForTextInput { userInput in
//        if let text = userInput {
//            print("User entered: \(text)")
//        } else {
//            print("User canceled text input.")
//        }
//    }

    
    func createAudioFileURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(generateUniqueName())
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
    
    func startAudioLevelMonitoring() {
        guard let audioRecorder = audioRecorder else { return }
        
        audioRecorder.isMeteringEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
    }
    
    @objc func updateMeters() {
        audioRecorder.updateMeters()
        
        let averagePower = audioRecorder.averagePower(forChannel: 0)
        let normalizedPower = (averagePower + 80) / 120
        self.visualizerView.updatePulse(with: normalizedPower)
    }

    
    func generateUniqueName() -> String {
        let uuid = UUID().uuidString.prefix(8)
        let uniqueString = "\(uuid).m4a"
        return uniqueString
    }

        func promptFileName() {
            guard let url = currentAudioFileName else { return }
            let alertController = UIAlertController(title: "Name your soundscape", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "\(url.lastPathComponent)"
            }
    
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let renameAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let self else { return }
                guard let newName = alertController.textFields?.first?.text else { return }
                if newName.isEmpty {
                    self.currentAudioFileName = self.createAudioFileURL()
                    return
                }
                print("NAME: --->", newName)
                let newURL = url.deletingLastPathComponent().appendingPathComponent(newName)
                do {
                    try FileManager.default.moveItem(at: url, to: newURL)
                    print("File renamed to \(newName)")
                } catch {
                    print("Error renaming file: \(error.localizedDescription)")
                }
            }
            
            [cancelAction, renameAction].forEach { alertController.addAction($0) }
    
            present(alertController, animated: true)
        }
    
    
    @IBAction func reverbChanged(_ sender: UISlider) {
        audioPlayer.reverb?.wetDryMix = sender.value
    }
    
    
    @IBAction func compressonChanged(_ sender: UISlider) {
//        audioPlayer.compressionNode.wetDryMix = sender.value
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
//        performSegue(withIdentifier: SegueID.gotoPlay.rawValue, sender: self)
        promptFileName()
    }
}

class PulsatingCircleView: UIView {
    private var pulseLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        print("CIRCLE BOUNDS: ", bounds)

        pulseLayer = CALayer()
        pulseLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        pulseLayer.position = center
        pulseLayer.cornerRadius = radius
        pulseLayer.opacity = 0
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX / 2, y: bounds.midY / 2, width: radius, height: radius)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        pulseLayer.addSublayer(gradient)
        
        layer.addSublayer(pulseLayer)
    }
    
    func updatePulse(with audioLevel: Float) {
        let scale = 1 + CGFloat(audioLevel) * 0.9
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pulseLayer.transform = CATransform3DMakeScale(scale, scale, 1)
        pulseLayer.opacity = Float(audioLevel)
        CATransaction.commit()
    }
}

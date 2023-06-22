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
    //@IBOutlet weak var playVolume: UISlider!
    @IBOutlet weak var saveButtton: UIButton!
    
    @IBOutlet weak var savedFileName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var audioRecorder = HypnoAudioRecorder()
    var audioPlayer = AudioPlayer()
    var url = URL(string: "")
    
    var isRecording = false
    var isPlaying   = false
    var lastRecordingURL: URL?
    
//    var playVolumeLevel: Float {
//        playVolume.value * 100
//    }
    var reverbLevel: Float {
        reverbSlider.value * 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        //loadLastRecording()
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
            isRecording.toggle()
            playButton.isEnabled = false
            audioRecorder.startRecording()
            let stopImage = UIImage(systemName: "stop.fill")
            recordButton.setTitle("Stop", for: .normal)
            recordButton.setImage(stopImage, for: .normal)
            micImageView.tintColor = .red
        } else {
            isRecording.toggle()
            url = audioRecorder.getAudioURL()
            playButton.isEnabled = true
            audioRecorder.stopRecording()
            promptFileName()
            let recordImage = UIImage(systemName: "record.circle")
            recordButton.setTitle("Record", for: .normal)
            recordButton.setImage(recordImage, for: .normal)
            micImageView.tintColor = UIColor(named: Color.hlIndigo.rawValue)
            //loadLastRecording()
        }
    }
    
//    MARK: - Play
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isPlaying {
            isPlaying.toggle()
            recordButton.isEnabled = false
            audioPlayer.playAudio(audioURL: url!)
            //audioPlayer.audioPlayerNode?.volume = playVolumeLevel
            audioPlayer.reverb?.wetDryMix = reverbLevel
            //audioPlayer.reverb?.wetDryMix = reverbSlider.value
            print("Reverb Level", audioPlayer.reverb?.wetDryMix)
            
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
            //audioPlayer.audioPlayerNode?.volume = playVolumeLevel
            audioPlayer.reverb?.wetDryMix = reverbLevel
        }
    }
    
    func promptFileName() {
        let url = audioRecorder.getAudioURL()
        
        let alertController = UIAlertController(title: "Name your affirmation", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let renameAction = UIAlertAction(title: "Save", style: .default) { _ in
            let audioExt = ".m4a"
            guard let newName = alertController.textFields?.first?.text else { return }
            let newURL = url.deletingLastPathComponent().appendingPathComponent(newName + audioExt)
            self.url = newURL
            
            do {
                try FileManager.default.moveItem(at: url, to: newURL)
                print("File renamed to \(newName)")
                //self.loadLastRecording()
            } catch {
                print("Error renaming file: \(error.localizedDescription)")
            }
            self.loadLastRecording()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(renameAction)

        present(alertController, animated: true)
    }
    
    @IBAction func reverbChanged(_ sender: UISlider) {
       
    }
    
    @IBAction func compressonChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueID.gotoPlay.rawValue, sender: self)
    }
    
    @IBAction func deleteButtonPushed(_ sender: UIButton) {
        guard let lastRecording = lastRecordingURL else { return }
              do {
                  try FileManager.default.removeItem(at: lastRecording)
                  savedFileName.text = "No recordings found"
                  loadLastRecording()
                  //deleteButton.isHidden = true
              } catch {
                  print("Error deleting last recording: \(error.localizedDescription)")
              }
    }
    
    func loadLastRecording() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: nil, options: [])
            let recordings = files.filter { $0.pathExtension == "m4a" }

            if let lastRecording = recordings.last {
                lastRecordingURL = lastRecording
                savedFileName.text = lastRecording.lastPathComponent
            } else {
                savedFileName.text = "No recordings found"
                deleteButton.isHidden = true
            }
        } catch {
            print("Error loading last recording: \(error.localizedDescription)")
        }
    }
}

//
//  HypnoAudioRecorder.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 3/14/23.
//

import AVFoundation

class HypnoAudioRecorder: NSObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder?

    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
            let audioURL = getAudioURL()
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            print("Error starting recording")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
    }

    func getAudioURL() -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let audioFilename = "audio.m4a"
        let audioURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(audioFilename)
        return audioURL
    }
}

class AudioPlayer: NSObject {
    var audioPlayerNode: AVAudioPlayerNode?
    var audioFile: AVAudioFile?
    var audioEngine: AVAudioEngine?
    var reverb: AVAudioUnitReverb?

    func playAudio(audioURL: URL) {
        do {
            audioFile = try AVAudioFile(forReading: audioURL)
            audioPlayerNode = AVAudioPlayerNode()

            audioEngine = AVAudioEngine()
            reverb = AVAudioUnitReverb()
            reverb?.wetDryMix = 50

            audioEngine?.attach(audioPlayerNode!)
            audioEngine?.attach(reverb!)

            audioEngine?.connect(audioPlayerNode!, to: reverb!, format: audioFile?.processingFormat)
            audioEngine?.connect(reverb!, to: audioEngine!.mainMixerNode, format: audioFile?.processingFormat)

            audioPlayerNode?.scheduleFile(audioFile!, at: nil)

            try audioEngine?.start()
            audioPlayerNode?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }

    func stopAudio() {
        audioPlayerNode?.stop()
        audioEngine?.stop()
    }
}


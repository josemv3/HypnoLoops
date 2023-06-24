//
//  HypnoAudioRecorder.swift
//  Hypno Loops
//
//  Created by Olijujuan Green on 3/14/23.
//

import AVFoundation
import AVFAudio

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

class HypnoAudioPlayer: NSObject {
    var audioPlayerNode: AVAudioPlayerNode?
    var audioFile: AVAudioFile?
    var audioEngine: AVAudioEngine?
    var reverb: AVAudioUnitReverb?
    //var compressor: AVAudioUnitCompressor?

    func playAudio(audioURL: URL) {
        do {
            audioFile = try AVAudioFile(forReading: audioURL)
            audioPlayerNode = AVAudioPlayerNode()

            audioEngine = AVAudioEngine()
            reverb = AVAudioUnitReverb()
            reverb?.wetDryMix = 50
            setReverbPreset(.largeRoom)
            
//            compressor = AVAudioUnitCompressor()
//            compressor?.threshold = -30 // Adjust as needed
//            compressor?.attackTime = 0.1
//            compressor?.releaseTime = 0.1
//            compressor?.ratio = 4 // Adjust as needed
//            compressor?.makeupGain = 0 // Adjust as needed

            audioEngine?.attach(audioPlayerNode!)
            audioEngine?.attach(reverb!)
            //audioEngine?.attach(compressor!)

            audioEngine?.connect(audioPlayerNode!, to: reverb!, format: audioFile?.processingFormat)
            //audioEngine?.connect(audioPlayerNode!, to: compressor!, format: audioFile?.processingFormat)
            //audioEngine?.connect(compressor!, to: reverb!, format: audioFile?.processingFormat)
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
    
    func setReverbPreset(_ preset: AVAudioUnitReverbPreset) {
        reverb?.loadFactoryPreset(preset)
    }
}



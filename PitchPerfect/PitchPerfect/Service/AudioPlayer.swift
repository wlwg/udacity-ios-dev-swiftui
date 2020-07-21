//
//  Modified from:
//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Copyright Â© 2016 Udacity. All rights reserved.
//

import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var playing: Bool = false
    @Published var alert: AlertContent?
    
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var audioFile: AVAudioFile!
    
    struct AlertTitles {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }

    func setupAudio(recordedAudioURL: URL) {
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL)
            alert = nil
        } catch {
            alert = AlertContent(title: AlertTitles.AudioFileError, message: error.localizedDescription)
        }
    }
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        var audioNodes: Array<AVAudioNode> =  []
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        audioNodes.append(audioPlayerNode)
        
        // node for adjusting rate/pitch
        if pitch != nil || rate != nil {
            let changeRatePitchNode = AVAudioUnitTimePitch()
            if let pitch = pitch {
                changeRatePitchNode.pitch = pitch
            }
            if let rate = rate {
                changeRatePitchNode.rate = rate
            }
            audioEngine.attach(changeRatePitchNode)
            audioNodes.append(changeRatePitchNode)
        }
        
        
        // node for echo
        if echo {
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine.attach(echoNode)
            audioNodes.append(echoNode)
        }
        
        // node for reverb
        if reverb {
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attach(reverbNode)
            audioNodes.append(reverbNode)
        }
        
        audioNodes.append(audioEngine.outputNode)
 
        connectAudioNodes(audioNodes)

        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(AudioPlayer.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
        }
        
        do {
            try audioEngine.start()
        } catch {
            alert = AlertContent(title: AlertTitles.AudioEngineError, message: error.localizedDescription)
            return
        }

        // play the recording!
        audioPlayerNode.play()

        playing = true
        alert = nil
    }
    
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
               
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        playing = false
        alert = nil
    }

    func connectAudioNodes(_ nodes: Array<AVAudioNode>) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
}

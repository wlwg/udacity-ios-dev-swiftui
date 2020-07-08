//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by Will Wang on 2020-07-07.
//  Copyright © 2020 Udacity. All rights reserved.
//

import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var recording: Bool = false
    @Published var recordFinished: Bool = false
    @Published var recordURL: URL?
    @Published var alert: AlertContent?
    
    var audioRecorder: AVAudioRecorder!

    func startRecording() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch authStatus {
            case .authorized:
                self.startRecordingInternal()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    if granted {
                        self.startRecordingInternal()
                    }
                }
            case .denied, .restricted:
                alert = AlertContent(
                    title: "Microphone Permission Required",
                    message: "Please go to Settings->Privacy->Microphone, and enable the permission."
                )
            default:
                return
        }
        
    }
    
    func startRecordingInternal() {
        recording = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask,
                true
            )[0] as String
        let filePath = URL(string: "\(dirPath)/recordedVoice.wav")

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(
            AVAudioSession.Category.playAndRecord,
            mode: AVAudioSession.Mode.default,
            options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! session.setActive(true)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func stopRecording() {
        recording = false

        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    func clearRecording() {
        recordFinished = false
        if recordURL != nil {
            try! FileManager.default.removeItem(atPath: recordURL!.absoluteString)
            recordURL = nil
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordURL = audioRecorder.url
            recordFinished = true
        } else {
            print("Error")
        }
    }
}

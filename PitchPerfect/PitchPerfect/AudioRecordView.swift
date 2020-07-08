//
//  ContentView.swift
//  PitchPerfect
//
//  Created by Will Wang on 2020-07-06.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import AVFoundation

struct AudioRecordView: View {
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var showAlert: Bool {
        audioRecorder.alert != nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)

                VStack {
                    Button(action: {
                        self.audioRecorder.startRecording()
                    }) {
                        Image("Record")
                            .renderingMode(.original)
                            .opacity(audioRecorder.recording ? 0.5 : 1)
                    }
                    .disabled(audioRecorder.recording)

                    Text(audioRecorder.recording ? "Recording in progress" : "Tap to Record")
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
       

                NavigationLink(
                    destination: AudioPlayView(audioURL: audioRecorder.recordURL)
                        .onDisappear() {
                            self.audioRecorder.clearRecording()
                        },
                    isActive: $audioRecorder.recordFinished
                ) {
                    Button(action: {
                        self.audioRecorder.stopRecording()
                    }) {
                        Image("Stop")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 64, height: 64)
                            .opacity(audioRecorder.recording ? 1 : 0.5)
                    }
                    .disabled(!audioRecorder.recording)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .top)
                }
            }
        }
        .alert(isPresented: .constant(showAlert)) {
            Alert(
                title: Text(audioRecorder.alert!.title),
                message: Text(audioRecorder.alert!.message),
                dismissButton: .default(Text("OK")))
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordView()
    }
}

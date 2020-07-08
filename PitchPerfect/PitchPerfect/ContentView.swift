//
//  ContentView.swift
//  PitchPerfect
//
//  Created by Will Wang on 2020-07-06.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct RecordSoundsView: View {
    @State private var recording: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)

            VStack {
                Button(action: {
                    print("started recording")
                    self.recording = true
                }) {
                    Image("Record")
                        .renderingMode(.original)
                        .opacity(recording ? 0.5 : 1)
                }
                .disabled(recording)
                Text("Tap to Record")
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
   
            Button(action: {
                print("stopped recording")
                self.recording = false
            }) {
                Image("Stop")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .opacity(recording ? 1 : 0.5)
            }
            .disabled(!recording)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecordSoundsView()
    }
}

//
//  ContentView.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import AVFoundation
import Photos


struct AlertContent {
    let title: String
    let message: String
}

struct ContentView: View {
    @State private var image: Image?
    @State private var showImagePicker: Bool = false
    @State private var imageSource = UIImagePickerController.SourceType.photoLibrary
    @State private var alert: AlertContent?

    var showAlert: Bool {
        alert != nil
    }

    var body: some View {
        NavigationView {
            VStack {
                MemeViewerRepresentation(image: self.$image)
                HStack {
                    Spacer()
                    Button(action: {
                        self.imageSource = UIImagePickerController.SourceType.camera
                        self.openCamera()
                    }) {
                         Image(systemName: "camera")
                    }
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                    
                    Spacer()
                    Divider().frame(height: 30)
                    Spacer()
                    
                    Button(action: {
                        self.imageSource = UIImagePickerController.SourceType.photoLibrary
                        self.openPhotoLibrary()
                    }) {
                        Text("Album")
                    }
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary))

                    Spacer()
                }
                .padding()
                .background(Color.white)
                .opacity(0.7)
            }
            .navigationBarTitle("MemeMe", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    
                }){
                    Image(systemName: "square.and.arrow.up")
                }
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerRepresentation(image: self.$image, imageSource: self.$imageSource)
        }
        .alert(isPresented: .constant(showAlert)) {
            Alert(
                title: Text(self.alert!.title),
                message: Text(self.alert!.message),
                dismissButton: .default(Text("OK")))
        }
    }

    func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video)
        {
            case .authorized:
                self.openImagePicker()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openImagePicker()
                    }
                }
            case .denied, .restricted:
                self.alert = AlertContent(
                    title: "Camera Permission Required",
                    message: "Please go to Settings->Privacy->Camera, and enable the permission for this app."
                )
            default:
                return
        }
    }
    
    func openPhotoLibrary() {
        print(UIImagePickerController.isSourceTypeAvailable(self.imageSource))
        switch PHPhotoLibrary.authorizationStatus()
        {
            case .authorized:
                self.openImagePicker()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { status in
                    if status == .authorized {
                        self.openImagePicker()
                    }
                }
            case .denied, .restricted:
                self.alert = AlertContent(
                    title: "Photo Library Permission Required",
                    message: "Please go to Settings->Privacy->Photo, and enable the permission for this app."
                )
            default:
                return
        }
    }
    
    func openImagePicker() {
        self.showImagePicker = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

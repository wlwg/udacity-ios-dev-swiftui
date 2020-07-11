//
//  ImagePicker.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import AVFoundation
import Photos


struct AlertContent {
    let title: String
    let message: String
}

struct ImagePickerRepresentation: UIViewControllerRepresentable
{
    @Binding var image: Image?
    @Binding var imageSource: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let representer: ImagePickerRepresentation
    
        init(_ representer: ImagePickerRepresentation) {
            self.representer = representer
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                representer.image = Image(uiImage: uiImage)
            }
            representer.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerRepresentation>) -> UIImagePickerController {
        let uiImagePicker = UIImagePickerController()
        uiImagePicker.delegate = context.coordinator
        uiImagePicker.sourceType = imageSource
        return uiImagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ImagePickerView: View {
    @EnvironmentObject var meme: MemeModel

    @State private var showImagePicker: Bool = false
    @State private var imageSource = UIImagePickerController.SourceType.photoLibrary
    @State private var alert: AlertContent?

    var showAlert: Bool {
        alert != nil
    }

    var body: some View {
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
        .sheet(isPresented: $showImagePicker) {
            ImagePickerRepresentation(image: self.$meme.image, imageSource: self.$imageSource)
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

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}

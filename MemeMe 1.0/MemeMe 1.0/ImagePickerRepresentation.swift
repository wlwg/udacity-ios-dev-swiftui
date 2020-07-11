//
//  ImagePickerRepresentation.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

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

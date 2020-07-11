//
//  MemeEditorView.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import AVFoundation
import Photos

struct MemeEditor: View {
    @EnvironmentObject var meme: MemeModel
    @State private var editingTopText: Bool = false
    @State private var editingBottomText: Bool = false
    
    @ObservedObject private var keyboard = KeyboardResponder()

    var body: some View {
        ZStack {
            Rectangle()

            if meme.image != nil {
                meme.image!
                    .resizable()
                    .scaledToFit()
                    .animation(.easeIn(duration: 0.2))
            }

            VStack {
                ZStack {
                    if !editingTopText {
                        Text(meme.topText.isEmpty ? "TOP" : meme.topText)
                            .font(
                                Font.custom("HelveticaNeue-CondensedBlack", size: 40)
                                
                            )
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
    
                    TextField("", text: $meme.topText, onEditingChanged: { (editing) in
                        self.editingTopText = editing
                        self.keyboard.active = false
                    }) {
                        self.editingTopText = false
                    }.frame(height: 40)
                        .font(Font.custom("HelveticaNeue-CondensedBlack", size: 40))
                        .autocapitalization(.allCharacters)
                        .multilineTextAlignment(.center)
                        .foregroundColor(editingTopText ? .white : .clear)
                        .background(Color.clear)
                        .padding()
                }.padding(.top, 50)

                Spacer()

                ZStack {
                    if !editingBottomText {
                        Text(meme.bottomText.isEmpty ? "BOTTOM" :  meme.bottomText)
                            .font(Font.custom("HelveticaNeue-CondensedBlack", size: 40))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    TextField("", text: $meme.bottomText, onEditingChanged: { (editing) in
                        self.editingBottomText = editing
                        self.keyboard.active = true
                    }) {
                        self.editingBottomText = false
                    }
                        .font(Font.custom("HelveticaNeue-CondensedBlack", size: 40))
                        .autocapitalization(.allCharacters)
                        .multilineTextAlignment(.center)
                        .foregroundColor(editingBottomText ? .white : .clear)
                        .background(Color.clear)
                        .padding()
                }.padding(.bottom, 50)
            }
        }
        .offset(y: -keyboard.keyboardHeight)
        .animation(.easeOut(duration: 0.2))
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}


/*
 Use UIViewController as a bridge for taking screenshot due to some functionality limitation in SwiftUI.
 */
struct MemeEditorView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIHostingController<MemeEditor> {
        return UIHostingController(rootView: MemeEditor())
    }

    func updateUIViewController(_ uiViewController: UIHostingController<MemeEditor>, context: Context) {
    }
}


struct MemeViewer_Previews: PreviewProvider {
    static var previews: some View {
        MemeEditorView()
    }
}

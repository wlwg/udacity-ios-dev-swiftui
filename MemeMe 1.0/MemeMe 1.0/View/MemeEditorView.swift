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
import Combine

struct MemeEditorView: View {
    @EnvironmentObject var meme: MemeModel
    @ObservedObject private var keyboard = KeyboardResponder()

    @State private var topText: String = ""
    @State private var bottomText: String = ""
    @State private var editingTopText: Bool = false
    @State private var editingBottomText: Bool = false

    private struct Style {
        static let bottomBarHeight: Int = 40
        static let bottomTextPaddingBottom: Int = 20
        static let topTextPaddingTop: Int = 20
        static let textFontSize = 40
    }

    var body: some View {
        VStack {
            ZStack {
                Rectangle()

                if meme.image != nil {
                    meme.image!
                        .resizable()
                        .scaledToFit()
                        .animation(.easeIn(duration: 0.2))
                } else {
                    Text("No image selected.").foregroundColor(.white)
                }

                VStack {
                    ZStack {
                        if !editingTopText {
                            Text(meme.topText.isEmpty ? "TOP" : meme.topText)
                                .font(
                                    Font.custom("HelveticaNeue-CondensedBlack", size: CGFloat(Style.textFontSize))
                                )
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black, radius: 2)
                        }
        
                        TextField("", text: $topText, onEditingChanged: { (editing) in
                            self.editingTopText = editing
                            self.keyboard.active = false
                        }) {
                            self.editingTopText = false
                            self.meme.topText = self.topText
                        }
                            .shadow(color: .black, radius: 2)
                            .frame(height: 50)
                            .font(
                                Font.custom("HelveticaNeue-CondensedBlack", size: CGFloat(Style.textFontSize))
                            )
                            .autocapitalization(.allCharacters)
                            .multilineTextAlignment(.center)
                            .foregroundColor(editingTopText ? .white : .clear)
                            .background(Color.clear)
                            .padding()
                    }.padding(.top, CGFloat(Style.topTextPaddingTop))

                    Spacer()

                    ZStack {
                        if !editingBottomText {
                            Text(meme.bottomText.isEmpty ? "BOTTOM" :  meme.bottomText)
                                .font(Font.custom("HelveticaNeue-CondensedBlack", size: CGFloat(Style.textFontSize)))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black, radius: 2)
                        }

                        TextField("", text: $bottomText, onEditingChanged: { (editing) in
                            self.editingBottomText = editing
                            self.keyboard.active = true
                        }) {
                            self.editingBottomText = false
                            self.meme.bottomText = self.bottomText
                        }
                            .shadow(color: .black, radius: 2)
                            .frame(height: 50)
                            .font(Font.custom("HelveticaNeue-CondensedBlack", size: CGFloat(Style.textFontSize)))
                            .autocapitalization(.allCharacters)
                            .multilineTextAlignment(.center)
                            .foregroundColor(editingBottomText ? .white : .clear)
                            .background(Color.clear)
                            .padding()
                    }.padding(.bottom, CGFloat(Style.bottomTextPaddingBottom))
                }
            }
            .animation(.easeOut(duration: 0.2))
            
            ImagePickerView()
                .frame(height: CGFloat(Style.bottomBarHeight), alignment: .center)
        }
        .offset(
            y: keyboard.keyboardHeight > 0
                ? -keyboard.keyboardHeight + CGFloat(Style.bottomBarHeight) + CGFloat(Style.bottomTextPaddingBottom)
                : 0
        )
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

struct MemeViewer_Previews: PreviewProvider {
    static var previews: some View {
        MemeEditorView()
    }
}

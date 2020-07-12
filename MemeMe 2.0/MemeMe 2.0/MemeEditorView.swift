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

struct MemeEditorViewInternal: View {
    let generateMemedImage: () -> UIImage
    let onDismiss: () -> Void
    @Binding var meme: MemeModel

    @ObservedObject private var keyboard = KeyboardResponder()

    @State private var editingTopText: Bool = false
    @State private var editingBottomText: Bool = false
    @State private var showShare: Bool = false
    @State private var memedImage: UIImage? = nil

    private struct Style {
        static let bottomBarHeight: Int = 40
        static let bottomTextPaddingBottom: Int = 20
        static let topTextPaddingTop: Int = 20
        static let textFontSize = 40
    }

    var body: some View {
        NavigationView {
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
            
                            TextField("", text: $meme.topText, onEditingChanged: { (editing) in
                                self.editingTopText = editing
                                self.keyboard.active = false
                            }) {
                                self.editingTopText = false
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

                            TextField("", text: $meme.bottomText, onEditingChanged: { (editing) in
                                self.editingBottomText = editing
                                self.keyboard.active = true
                            }) {
                                self.editingBottomText = false
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
                
                ImagePickerView(image: $meme.image)
                    .frame(height: CGFloat(Style.bottomBarHeight), alignment: .center)
            }
            .offset(
                y: keyboard.keyboardHeight > 0
                    ? -keyboard.keyboardHeight + CGFloat(Style.bottomBarHeight) + CGFloat(Style.bottomTextPaddingBottom)
                    : 0
            )
            .navigationBarTitle("Meme Editor", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.memedImage = self.generateMemedImage()
                    self.showShare = true
                }){
                    Image(systemName: "square.and.arrow.up")
                },
                trailing: Button("Cancel") {
                    self.onDismiss()
                }
            )
        }
        .sheet(isPresented: $showShare) {
            ActivityView(activityItems: [self.memedImage!])
        }
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
class MemeEditorViewController: UIViewController {
    var meme: Binding<MemeModel>
    let onDismiss: () -> Void
    
    init(meme: Binding<MemeModel>, onDismiss: @escaping () -> Void) {
        self.meme = meme
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.meme = .constant(MemeModel())
        self.onDismiss = {}
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let contentViewContainer = UIHostingController(rootView:
            MemeEditorViewInternal(
                generateMemedImage: self.generateMemedImage,
                onDismiss: self.onDismiss,
                meme: self.meme
            )
        )
        addChild(contentViewContainer)
        view.addSubview(contentViewContainer.view)
        contentViewContainer.didMove(toParent: self)

        contentViewContainer.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewContainer.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        contentViewContainer.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contentViewContainer.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        contentViewContainer.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }

    func generateMemedImage() -> UIImage {
        let topBarHeight = 50.0
        let bottomBarHeight = 50.0
        let size = CGSize(
            width: self.view.frame.width,
            height: self.view.frame.height - CGFloat(topBarHeight) - CGFloat(bottomBarHeight)
        )
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        view.drawHierarchy(
            in: .init(origin: .init(x: 0, y: -topBarHeight), size: self.view.frame.size),
            afterScreenUpdates: true
        )
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}

struct MemeEditorView: UIViewControllerRepresentable {
    @Binding var meme: MemeModel
    let onDismiss: () -> Void

    func makeUIViewController(context: Context) -> MemeEditorViewController {
        return MemeEditorViewController(
            meme: $meme,
            onDismiss: self.onDismiss
        )
    }

    func updateUIViewController(_ uiViewController: MemeEditorViewController, context: Context) {
    }
}

struct MemeViewer_Previews: PreviewProvider {
    static var previews: some View {
        MemeEditorView(
            meme: .constant(MemeModel()),
            onDismiss: {}
        )
    }
}

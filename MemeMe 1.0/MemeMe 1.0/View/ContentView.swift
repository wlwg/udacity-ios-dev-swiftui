//
//  ContentView.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import Combine

struct ContentViewInternal: View {
    let generateMemedImage: () -> Void
    
    @EnvironmentObject var meme: MemeModel
    @State private var showShare: Bool = false

    var body: some View {
        NavigationView {
            MemeEditorView()
            .navigationBarTitle("MemeMe", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    self.generateMemedImage()
                    self.showShare = true
                }){
                    Image(systemName: "square.and.arrow.up")
                }
            )
        }
        .sheet(isPresented: $showShare) {
            ActivityView(activityItems: [self.meme.memedImage!])
        }
    }
}

/*
 Use UIViewController as a bridge for taking screenshot due to some functionality limitation in SwiftUI.
 */
class ContentViewController: UIViewController {
    private var subscriber: AnyCancellable?
    private var meme: MemeModel = MemeModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let contentViewContainer = UIHostingController(rootView:
            ContentViewInternal(generateMemedImage: generateMemedImage).environmentObject(meme)
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

    func generateMemedImage() {
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
        self.meme.memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
}

struct ContentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ContentViewController {
        return ContentViewController()
    }

    func updateUIViewController(_ uiViewController: ContentViewController, context: Context) {
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

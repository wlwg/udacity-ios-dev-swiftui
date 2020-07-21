//
//  MemeCollectionView.swift
//  MemeMe 2.0
//
//  Created by Will Wang on 2020-07-12.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI


let COLLECTION_CELL_REUSE_ID = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    var memes: [MemeModel] = []
    var onSelect: (MemeModel) -> Void = {meme in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: COLLECTION_CELL_REUSE_ID)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = self.memes[(indexPath as NSIndexPath).row]
        onSelect(meme)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_CELL_REUSE_ID, for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        self.addImageToCell(cell, image: meme.memedImage!)
        return cell
    }
    
    func addImageToCell(_ cell: UICollectionViewCell, image: Image) {
        cell.subviews.forEach({ $0.removeFromSuperview() })

        let cellSubViewController = UIHostingController(rootView: MemeCollectionViewCell(image: image))
        addChild(cellSubViewController)
        
        let subView = cellSubViewController.view!
        cell.addSubview(subView)

        cellSubViewController.didMove(toParent: self)
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        subView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        subView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
    }
}


struct MemeCollectionView: UIViewControllerRepresentable {
    @EnvironmentObject var appState: AppState

    let onClickMeme: (MemeModel) -> Void

    func makeUIViewController(context: Context) -> MemeCollectionViewController {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 3
        collectionLayout.minimumInteritemSpacing = 3
        collectionLayout.itemSize = CGSize(width: CGFloat(160), height: CGFloat(160))
        
        let collectionViewController = MemeCollectionViewController(collectionViewLayout: collectionLayout)
        collectionViewController.memes = self.appState.memes
        collectionViewController.onSelect = self.onClickMeme
        return collectionViewController
    }
    
    func updateUIViewController(_ uiViewController: MemeCollectionViewController, context: Context) {
        uiViewController.memes = self.appState.memes
        uiViewController.collectionView.reloadData()
    }
}

struct MemeCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MemeCollectionView(onClickMeme: {meme in
            print(meme)
        })
    }
}

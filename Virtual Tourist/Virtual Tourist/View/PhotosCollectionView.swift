//
//  PhotosCollectionView.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData


class PhotosCollectionViewController: UICollectionViewController {
    static let COLLECTION_CELL_REUSE_ID = "PhotosCollectionViewCell"

    private var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchRequest: NSFetchRequest<Photo>?

    var location: Location?
    var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewController.COLLECTION_CELL_REUSE_ID)
        self.collectionView.delegate = self

        fetchRequest = Photo.fetchRequest()
        fetchRequest!.sortDescriptors = []
        fetchRequest!.predicate = NSPredicate(format: "location == %@", location!)
        
        self.reloadData()
    }
    
    func reloadData() {
        do {
            self.photos = try self.managedObjectContext.fetch(fetchRequest!)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        self.collectionView.reloadData()
    }
    
    private func deletePhoto(_ photo: Photo) {
        self.managedObjectContext.delete(photo)
        try? managedObjectContext.save()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = self.photos[indexPath.item]
        self.photos.remove(at: indexPath.item)

        collectionView.deleteItems(at: [indexPath])

        self.deletePhoto(photo)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewController.COLLECTION_CELL_REUSE_ID, for: indexPath)
        cellView.backgroundColor = UIColor.gray
        self.setupCollectionCellView(cellView, photo: self.photos[indexPath.item])

        return cellView
    }
    
    func setupCollectionCellView(_ cell: UICollectionViewCell, photo: Photo) {
        cell.subviews.forEach({ $0.removeFromSuperview() })
        
        let cellSubViewController = UIHostingController(
            rootView: PhotoView(photo: photo)
        )
        addChild(cellSubViewController)
        
        let subView = cellSubViewController.view!
        cell.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        subView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        subView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
    }
}


extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = self.photos[indexPath.row]

        let cellWidth = collectionView.bounds.width/3 - 2
        let cellHeight = cellWidth * CGFloat(photo.height) / CGFloat(photo.width)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}



struct PhotosCollectionView: UIViewControllerRepresentable {
    private var uiViewController: PhotosCollectionViewController

    init(location: Location) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let uiViewController = PhotosCollectionViewController(collectionViewLayout: layout)
        uiViewController.location = location
        self.uiViewController = uiViewController
    }

    func makeUIViewController(context: Context) -> PhotosCollectionViewController {
        return self.uiViewController
    }
    
    func updateUIViewController(_ uiViewController: PhotosCollectionViewController, context: Context) {
    }
    
    func reloadData() {
        self.uiViewController.reloadData()
    }
}

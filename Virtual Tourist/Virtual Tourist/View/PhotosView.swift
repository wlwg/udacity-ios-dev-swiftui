//
//  PhotosView.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import CoreData

struct PhotoAlbumView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    private var location: Location
    private var photoFetchRequest: FetchRequest<Photo>
    private var photos: FetchedResults<Photo> {
        photoFetchRequest.wrappedValue
    }
    
    @State private var photosLoaded: Bool = false
    @State private var fetching: Bool = true
    @State private var fetchError: Bool = false
    
    init(location: Location) {
        self.location = location
        self.photoFetchRequest = FetchRequest(entity: Photo.entity(), sortDescriptors: [], predicate: NSPredicate(format: "location == %@", self.location), animation: nil)
    }

    var body: some View {
        NavigationView {
            VStack {
                LocationView(location: location)

                if fetching {
                    LoadingView()
                } else if fetchError {
                    Text("Something unexpected occurred. Please retry later.")
                } else {
                    PhotosCollectionView(location: location, onLoadFinish: {
                        self.photosLoaded = true
                    })
                }

                Button(action: {
                    
                }) {
                    Text("New Collection")
                        .foregroundColor(.white)
                        .frame( maxWidth: .infinity, minHeight: 40)
                        .background(Color.primaryColor)
                        .cornerRadius(5)
                }
                .opacity(photosLoaded ? 1 : 0.5)
                .disabled(!photosLoaded)
            }.navigationBarTitle("Photo Album", displayMode: .inline)
            .navigationBarItems(leading: Image("icon_back-arrow").onTapGesture {
                
            })
        }
    }
    
    func fetchPhotos() {
        self.fetching = true
        FlickrClient().searchPhotos(latitude: location.latitude, longitude: location.longitude, limit: 30) {fetchResponse, error in
            guard let response = fetchResponse else {
                self.fetchError = true
                self.fetching = false
                return
            }
            
            for photoData in response.photos.photo {
                let photo = Photo(context: self.managedObjectContext)
                photo.id = UUID()
                photo.url = photoData.url
            }
            
            try? self.managedObjectContext.save()
            self.fetchError = false
            self.fetching = false
        }
    }
}

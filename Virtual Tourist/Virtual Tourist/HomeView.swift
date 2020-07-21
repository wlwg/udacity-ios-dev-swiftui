//
//  ContentView.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State var currentLocation: Location?
    var showPhotosView: Bool {
        currentLocation != nil
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                LocationsView(onTapLocation: {location in
                    self.currentLocation = location
                })
                .navigationBarTitle("Virtual Tourist", displayMode: .inline)
            }

            if showPhotosView {
                LocationAlbumView(
                    location: self.currentLocation!,
                    onDismiss: {
                        self.currentLocation = nil
                    }
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration:0.3))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

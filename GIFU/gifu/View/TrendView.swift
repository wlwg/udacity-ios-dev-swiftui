//
//  TrendView.swift
//  gifu
//
//  Created by Will Wang on 2020-07-21.
//  Copyright © 2020 EezyFun. All rights reserved.
//

import SwiftUI

struct TrendView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Gif.entity(), sortDescriptors: [], predicate: NSPredicate(format: "trending != nil"), animation: nil) var trendingGifsFetchedResults: FetchedResults<Gif>
    
    @State private var loading: Bool = true
    @State private var requestFailed: Bool = false
    @State private var gifs: [Gif] = []

    var body: some View {
        NavigationView {
            Group {
                if loading {
                    LoadingView()
                } else if requestFailed {
                    Text("Something unexpected occurred. We are trying to fix it.")
                        .foregroundColor(.primaryColor)
                } else {
                    GifsGridView(gifs: $gifs)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .navigationBarTitle("Trending", displayMode: .inline)
        }
        .onAppear() {
            self.getTrending()
        }
    }
    
    func getTrending() {
        self.requestFailed = false
        self.loading = true
        
        if self.trendingGifsFetchedResults.count > 0 {
            let trending = self.trendingGifsFetchedResults.first!.trending!
            if Date().timeIntervalSince(trending.updatedAt!) < 3600 {
                self.updateGifs()
                self.loading = false
                return
            }

            self.managedObjectContext.delete(trending)
            try? self.managedObjectContext.save()
        }

        let trending = Trending(context: managedObjectContext)
        trending.updatedAt = Date()

        GiphyClient().trending() { success, response in
            guard success else {
                self.requestFailed = true
                self.loading = false
                return
            }
            
            for dataItem in response!.data {
                let image = dataItem.images.image
                let gif = Gif(context: self.managedObjectContext)
                gif.id = UUID()
                gif.url = image.url
                gif.height = Int16(image.height)!
                gif.width = Int16(image.width)!
                gif.trending = trending
            }
            try? self.managedObjectContext.save()
            self.updateGifs()
            self.loading = false
        }
    }
    
    private func updateGifs() {
        var gifs: [Gif] = []
        for gif in self.trendingGifsFetchedResults {
            gifs.append(gif)
        }
        self.gifs = gifs
    }
}

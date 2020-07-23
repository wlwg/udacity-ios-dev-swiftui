//
//  SearchView.swift
//  gifu
//
//  Created by Will Wang on 2020-07-21.
//  Copyright © 2020 EezyFun. All rights reserved.
//

import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Search.entity(), sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)]) var searchFetchRequest: FetchedResults<Search>
    
    @State private var searchKeyword: String = ""
    @State private var loading: Bool = true
    @State private var requestFailed: Bool = false
    @State private var gifs: [Gif] = []
    
    enum UserDefaultKey: String {
        case searchKeyword
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.primaryColor)
                        .padding(.trailing, 4)
                    TextField(
                        "",
                        text: $searchKeyword,
                        onEditingChanged: { editting in },
                        onCommit: {
                            if !self.searchKeyword.isEmpty {
                                self.saveSearchKeyword(keyword: self.searchKeyword)
                                self.searchGif(keyword: self.searchKeyword)
                            }
                        }
                    )
                    .font(.headline)
                }
                .frame(height: 16)
                .padding(.all, 16)
                .overlay(
                    Capsule(style: .circular)
                        .stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 2))
                )

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
                .padding(.top, 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.top, 10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .navigationBarTitle("GIFU", displayMode: .inline)
        }.onAppear() {
            if let keyword = UserDefaults.standard.string(forKey: UserDefaultKey.searchKeyword.rawValue) {
                self.searchKeyword = keyword
            } else {
                self.searchKeyword = "you are awesome" // default search keyword
            }
            self.searchGif(keyword: self.searchKeyword)
        }
    }
    
    func saveSearchKeyword(keyword: String) {
        UserDefaults.standard.set(keyword, forKey: UserDefaultKey.searchKeyword.rawValue)
    }
    
    func searchGif(keyword: String) {
        self.requestFailed = false
        self.loading = true

        if let search = searchFetchRequest.first(where: {$0.keyword == keyword}) {
            if !self.updateGifs(search: search) {
                self.requestFailed = true
            }

            search.updatedAt = Date()
            try? self.managedObjectContext.save()
            
            if self.gifs.count == 0 {
                self.fetchGifs(keyword: keyword, search: search)
            } else {
                self.loading = false
            }
            return
        }
        
        let search = Search(context: self.managedObjectContext)
        search.keyword = keyword
        search.updatedAt = Date()
        
        if self.searchFetchRequest.count > 5 {
            self.managedObjectContext.delete(searchFetchRequest.last!)
        }

        self.fetchGifs(keyword: keyword, search: search)
    }
    
    private func fetchGifs(keyword: String, search: Search) {
        GiphyClient().search(keyword: keyword) { success, response in
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
                gif.search = search
            }

            if !self.updateGifs(search: search) {
                self.requestFailed = true
            }

            self.loading = false

            try? self.managedObjectContext.save()
        }
    }
    
    private func updateGifs(search: Search) -> Bool {
        let gifsFetchRequest = NSFetchRequest<Gif>(entityName: Gif.entity().name!)
        gifsFetchRequest.sortDescriptors = []
        gifsFetchRequest.predicate = NSPredicate(format: "search == %@", search)
        do {
            self.gifs = try self.managedObjectContext.fetch(gifsFetchRequest)
            return true
        } catch {
            print(error)
            return false
        }
    }
}

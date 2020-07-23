//
//  HomeView.swift
//  gifu
//
//  Created by Will Wang on 2020-07-20.
//  Copyright © 2020 EezyFun. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            SearchView()
            .tabItem(){
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            }
            
            TrendView()
            .tabItem() {
                VStack {
                    Image(systemName: "chart.bar.fill")
                    Text("Trending")
                }
            }
        }.accentColor(.primaryColor)
    }
}

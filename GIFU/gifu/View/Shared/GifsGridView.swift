//
//  GifsGridView.swift
//  gifu
//
//  Created by Will Wang on 2020-07-22.
//  Copyright © 2020 EezyFun. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI


struct ColumnGifElement {
    let url: String
    let height: CGFloat
    let width: CGFloat
}


struct GifsGridView: View {
    @Binding var gifs: [Gif]

    private let numOfColumns: Int = 2
    private let columnSpace: Int = 5
    
    private var gifColumns: [[ColumnGifElement]] {
        var columns: [[ColumnGifElement]] = []
        var columnHeights: [CGFloat] = []
        let availableWidth = UIScreen.main.bounds.width - CGFloat(20+columnSpace*(numOfColumns-1))
        let columnWidth = availableWidth / CGFloat(numOfColumns)
        for (index, gif) in gifs.enumerated() {
            let gifHeight = columnWidth / CGFloat(gif.width) * CGFloat(gif.height)
            if (index < numOfColumns) {
                columns.append([ColumnGifElement(url: gif.url!, height: gifHeight, width: columnWidth)]);
                columnHeights.append(gifHeight);
            } else {
                let minHeightIndex: Int = columnHeights.firstIndex(of: columnHeights.min()!)!
                columns[minHeightIndex].append(
                    ColumnGifElement(url: gif.url!, height: gifHeight, width: columnWidth)
                )
                columnHeights[minHeightIndex] += gifHeight;
            }
        }
        return columns
    }
    
    var body: some View {
        Group {
            if gifs.count > 0 {
                ScrollView {
                    gifColumnsView.animation(.easeIn)
                }
            } else {
                Text("No gifs found.")
                    .foregroundColor(.primaryColor)
            }
        }
    }
    
    private var gifColumnsView: some View {
        HStack(alignment: .top) {
            ForEach(0..<self.gifColumns.count, id: \.self) { columnIndex in
                self.gifColumnView(gifColumn: self.gifColumns[columnIndex])
            }
        }
    }
    
    private func gifColumnView(gifColumn: [ColumnGifElement]) -> some View {
        return VStack {
            ForEach(0..<gifColumn.count, id: \.self) { gifIndex in
                return self.gifView(gifElement: gifColumn[gifIndex])
            }
        }
    }
    
    private func gifView(gifElement: ColumnGifElement) -> some View {
        return AnimatedImage(url: URL(string: gifElement.url))
            .onFailure() {error in
                print(error)
            }
            .resizable()
            .placeholder {
                Rectangle()
                    .foregroundColor(.secondary)
            }
            .indicator(SDWebImageActivityIndicator.medium)
            .transition(.fade)
            .frame(
                width: gifElement.width,
                height: gifElement.height
            )
            .cornerRadius(5)
    }
}

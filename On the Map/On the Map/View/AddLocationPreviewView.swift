//
//  AddLocationPreviewView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import MapKit

struct AddLocationPreviewView: View {
    @State var place: CLPlacemark

    let onConfirm: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ZStack {
                SingleLocationMapView(place: place)
                
                VStack {
                    Spacer()
                    Button(action: {
                        self.onConfirm()
                    }) {
                        Text("FINISH")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.primaryColor)
                            .cornerRadius(5)
                    }.padding()
                }.frame(maxHeight: .infinity)
            }
            .navigationBarTitle("Location Preview", displayMode: .inline)
            .navigationBarItems(leading: Image("icon_back-arrow").onTapGesture {
                self.onDismiss()
            })
        }
    }
}

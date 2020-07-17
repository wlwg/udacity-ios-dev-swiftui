//
//  AddLocationView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import MapKit

struct AddLocationView: View {
    @EnvironmentObject var appState: AppState
    
    @State var mapString: String = ""
    @State var mediaURL: String = ""

    @State var place: CLPlacemark? = nil
    @State var showPreview: Bool = false

    @State var alert: AlertContent?

    @State var isLoading: Bool = false
    
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Image("icon_world")
                        .frame(minHeight: 150)

                    VStack {
                        TextField("Your Location", text: $mapString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        
                        TextField("Your URL", text: $mediaURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            self.findLocation()
                        }) {
                            Text("FIND LOCATION")
                                .foregroundColor(.white)
                                .frame( maxWidth: .infinity, minHeight: 40)
                                .background(Color.primaryColor)
                                .cornerRadius(5)
                        }
                        .opacity(self.mapString.isEmpty || self.mediaURL.isEmpty ? 0.5 : 1)
                        .disabled(self.mapString.isEmpty || self.mediaURL.isEmpty)
                    }
                    .padding(20)
            
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .alert(item: $alert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: .default(Text("OK")) {
                            self.alert = nil
                        }
                    )
                }
                .navigationBarTitle("Add Location", displayMode: .inline)
                .navigationBarItems(leading:
                    Text("CANCEL")
                        .foregroundColor(.primaryColor)
                        .font(.caption)
                        .onTapGesture {
                            self.onDismiss()
                        }
                )
            }
            
            if showPreview {
                AddLocationPreviewView(
                    place: place!,
                    onConfirm: self.saveLocation,
                    onDismiss: {
                        self.showPreview = false
                    })
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration:0.4))
            }
            
            if isLoading {
                LoadingView()
            }
        }
    }
    
    func findLocation() {
        CLGeocoder().geocodeAddressString(self.mapString) { placeMark, error in
            guard let placeMark = placeMark else {
                print(error!) // TODO: send to log
                self.alert = AlertContent(title: "Cannot find the location", message: "Please double check the location you entered.")
                return
            }
            self.place = placeMark[0]
            self.showPreview = true
        }
    }
    
    func saveLocation() {
        isLoading = true
        let userInfo = appState.userInfo!
        APIClient.saveStudentLocation(
            uniqueKey: userInfo.userId,
            firstName: userInfo.userInfo!.firstName,
            lastName: userInfo.userInfo!.lastName,
            mapString: mapString,
            mediaURL: mediaURL,
            latitude: place!.location!.coordinate.latitude,
            longitude: place!.location!.coordinate.longitude,
            completionHandler: { studentLocation, error in
                self.isLoading = false
                guard let studentLocation = studentLocation else {
                    self.alert = AlertContent(title: "Failed to save location", message: error?.localizedDescription ?? "Something unexpected occurred.")
                    return
                }
                self.appState.studentLocations.insert(studentLocation, at: 0)
                self.showPreview = false
                self.onDismiss()
            }
        )
    }
}

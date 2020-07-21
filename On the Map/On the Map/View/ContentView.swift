//
//  ContentView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var loggedIn: Bool {
        return appState.userInfo != nil
    }
    
    @State var isLoading: Bool = false
    
    @State var showAddLocation: Bool = false
    @State var alert: AlertContent?
    
    var body: some View {
        ZStack {
            NavigationView {
                TabView {
                    VStack {
                        MapView(onTapItem: self.openURL)
                    }.tabItem {
                        Image("icon_mapview")
                            .renderingMode(.template)
                    }

                    VStack {
                        ListView(onTapItem: self.openURL)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                    }.tabItem {
                        Image("icon_listview")
                            .renderingMode(.template)
                    }
                }
                .accentColor(.primaryColor)
                .navigationBarTitle("On the Map", displayMode: .inline)
                .navigationBarItems(
                    leading: Text("LOGOUT").foregroundColor(.primaryColor).font(.caption).onTapGesture {
                        APIClient.logout(sessionId: self.appState.userInfo!.sessionId) { success, error in
                                if success {
                                    self.appState.userInfo = nil
                                } else {
                                    self.alert = AlertContent(title: "Logout Failed", message: error?.localizedDescription ?? "Something unexpected occurred.")
                                }
                            }
                        },
                    trailing:
                        Image("icon_addpin")
                            .renderingMode(.template)
                            .foregroundColor(.primaryColor)
                            .onTapGesture {
                                self.showAddLocation = true
                            }
                )
            }
            
            if showAddLocation {
                AddLocationView(onDismiss: {
                    self.showAddLocation = false
                })
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration:0.4))
            }
            
            if !loggedIn {
                LoginView(
                    onLoginError: self.onLoginError,
                    onLoggedIn: self.onLoggedIn
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration:0.4))
            }
            
            if isLoading {
                LoadingView()
            }
        }
        .onAppear() {
            if self.loggedIn {
                self.fetchStudentLocations()
            }
        }
        .alert(item: $alert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK")) {
                    self.alert = nil
                }
            )
        }
    }
    
    func onLoginError(error: Error?) {
        self.alert = AlertContent(
            title: "Login Failed",
            message: error?.localizedDescription ?? "Something unexpected occcurred."
        )
    }

    func onLoggedIn(user: User) {
        self.appState.userInfo = user
        self.fetchStudentLocations()
    }
    
    func fetchStudentLocations() {
        self.isLoading = true
        APIClient.getStudentLocations(limit: 100) {studentLocations, error in
            guard var studentLocations = studentLocations else {
                self.isLoading = false
                self.alert = AlertContent(
                    title: "Failed to fetch locations.",
                    message: error?.localizedDescription ?? "Something unexpected occcurred."
                )
                return
            }
            studentLocations.sort {
                $0.updatedAt > $1.updatedAt
            }
            self.appState.studentLocations = studentLocations
            self.isLoading = false
        }
    }
    
    func openURL(urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }

        self.alert = AlertContent(
            title: "Failed to open URL",
            message: "Empty or invalid media URL."
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

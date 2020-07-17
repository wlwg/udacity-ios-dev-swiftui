//
//  LoginView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isLoading: Bool = false
    
    let onLoginError: (Error?) -> Void
    let onLoggedIn: (User) -> Void
    
    var loginButtonDisabled: Bool {
        self.email.isEmpty || self.password.isEmpty || isLoading
    }

    var body: some View {
        ZStack {
            VStack {
                Image("logo-u")
                    .frame(minHeight: 150)

                VStack {
                    TextField("Email", text: $email, onEditingChanged: {_ in }, onCommit: {})
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    
                    
                    SecureField("Password", text: $password, onCommit: {})
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        self.login()
                    }) {
                        Text("LOG IN")
                            .foregroundColor(.white)
                            .frame( maxWidth: .infinity, minHeight: 40)
                            .background(Color.primaryColor)
                            .cornerRadius(5)
                    }
                    .opacity(loginButtonDisabled ? 0.5 : 1)
                    .disabled(loginButtonDisabled)
                }
                .padding(20)
                
                HStack {
                    Text("Don't have an account?").font(.subheadline)
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!)
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.primaryColor)
                            .font(.subheadline)
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            
            
            if isLoading {
                LoadingView()
            }
        }
    }
    
    func login() {
        self.isLoading = true
        APIClient.login(username: self.email, password: self.password) { user, loginError in
            guard var user = user else {
                self.isLoading = false
                self.onLoginError(loginError)
                return
            }
            APIClient.getUserInfo(userId: user.userId) { userInfo, getUserInfoError in
                self.isLoading = false
                guard let userInfo = userInfo else {
                    self.onLoginError(getUserInfoError)
                    return
                }
                user.userInfo = userInfo
                self.onLoggedIn(user)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onLoginError: {error in}, onLoggedIn: {user in})
    }
}

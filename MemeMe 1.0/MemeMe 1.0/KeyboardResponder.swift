//
//  KeyboardResponder.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-10.
//  Copyright © 2020 Udacity. All rights reserved.
//
//  Reference: https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui

import SwiftUI

final class KeyboardResponder: ObservableObject {
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    var active: Bool = true

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if !active {
            return
        }
        keyboardHeight = getKeyboardHeight(notification)
    }

    @objc func keyBoardWillHide(notification: Notification) {
        if !active {
            return
        }
        keyboardHeight = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

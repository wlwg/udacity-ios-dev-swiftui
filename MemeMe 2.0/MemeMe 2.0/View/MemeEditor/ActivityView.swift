//
//  ActivityView.swift
//  MemeMe 1.0
//
//  Created by Will Wang on 2020-07-11.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    let onShared: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        let viewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        viewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.onShared()
            }
        }
        viewController.modalPresentationStyle = .popover
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}

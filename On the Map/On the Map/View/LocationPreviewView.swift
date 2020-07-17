//
//  LocationPreviewView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import MapKit

struct SingleLocationView: UIViewRepresentable {
    @State var place: CLPlacemark

    class Coordinator: NSObject, MKMapViewDelegate {
        static let AnnotationViewReuseId = "LocationPreviewMapAnnotationViewReuseId"

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Coordinator.AnnotationViewReuseId) as? MKPinAnnotationView
            if let pinView = pinView {
                pinView.annotation = annotation
            }
            else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Coordinator.AnnotationViewReuseId)
                pinView!.pinTintColor = .red
            }
            
            return pinView
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.location!.coordinate
        annotation.title = place.name!
        uiView.addAnnotation(annotation)
    }
}

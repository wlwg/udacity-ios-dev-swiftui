//
//  MapView.swift
//  On the Map
//
//  Created by Will Wang on 2020-07-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var appState: AppState
    
    let onTapItem: (String?) -> Void

    class Coordinator: NSObject, MKMapViewDelegate {
        static let AnnotationViewReuseId = "MapAnnotationViewReuseId"

        let representer: MapView
        
        init(_ representer: MapView) {
            self.representer = representer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Coordinator.AnnotationViewReuseId) as? MKPinAnnotationView
            if let pinView = pinView {
                pinView.annotation = annotation
            }
            else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Coordinator.AnnotationViewReuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            
            return pinView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                self.representer.onTapItem(view.annotation?.subtitle!)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        var annotations = [MKPointAnnotation]()
        let locations: [StudentLocation] = appState.studentLocations
        for location in locations {
            let coordinate = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(location.latitude),
                longitude: CLLocationDegrees(location.longitude)
            )
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate

            annotation.title = location.fullName
            annotation.subtitle = location.mediaURL

            annotations.append(annotation)
        }

        uiView.addAnnotations(annotations)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(onTapItem: {string in})
    }
}

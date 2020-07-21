//
//  MapView.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import MapKit


struct LocationView: UIViewRepresentable {
    @State var location: Location
    
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>

    class Coordinator: NSObject, MKMapViewDelegate {
        static let AnnotationViewReuseId = "LocationView_MapAnnotationViewReuseId"

        let representer: LocationView
        
        init(_ representer: LocationView) {
            self.representer = representer
        }
        
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
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        self.addAnnotation(mapView)
        self.zoomIn(mapView)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func addAnnotation(_ uiView: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(location.latitude),
            longitude: CLLocationDegrees(location.longitude)
        )
        uiView.addAnnotation(annotation)
    }
    
    func zoomIn(_ uiView: MKMapView) {
        let coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(location.latitude),
            longitude: CLLocationDegrees(location.longitude)
        )
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
}

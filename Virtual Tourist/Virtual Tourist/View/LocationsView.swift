//
//  LocationsView.swift
//  Virtual Tourist
//
//  Created by Will Wang on 2020-07-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit



class IdentifiableMapAnnotation : MKPointAnnotation {
    var location : Location?
}

struct LocationsView: UIViewRepresentable {
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var locations: FetchedResults<Location>
    
    let onTapLocation: (Location) -> Void

    class Coordinator: NSObject, MKMapViewDelegate {
        static let AnnotationViewReuseId = "LocationsView_MapAnnotationViewReuseId"

        let representer: LocationsView
        
        init(_ representer: LocationsView) {
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
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let annotation = view.annotation as! IdentifiableMapAnnotation
            self.representer.onTapLocation(annotation.location!)
            mapView.deselectAnnotation(view.annotation, animated: false)
        }

        @objc
        func onLongPressOnMap(_ longPressRecognizer: UILongPressGestureRecognizer) {
            if longPressRecognizer.state != UIGestureRecognizer.State.began {
                return
            }

            let mapView = longPressRecognizer.view as! MKMapView
            let touchPoint = longPressRecognizer.location(in: mapView)
            let mapCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            let location = Location(context: self.representer.managedObjectContext)
            location.id = UUID()
            location.latitude = mapCoordinate.latitude
            location.longitude = mapCoordinate.longitude

            let annotation = IdentifiableMapAnnotation()
            annotation.location = location
            annotation.coordinate = mapCoordinate
            mapView.addAnnotation(annotation)
            
            do {
                try self.representer.managedObjectContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        @objc
        func onTapAnnotation(_ tapGesture: UITapGestureRecognizer) {
            let annotation = (tapGesture.view as! MKAnnotationView).annotation as! IdentifiableMapAnnotation
            self.representer.onTapLocation(annotation.location!)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        self.addAnnotations(mapView)
        self.addLongPressGesture(mapView, context: context)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }

    func addAnnotations(_ uiView: MKMapView) {
        var annotations = [IdentifiableMapAnnotation]()
        for location in locations {
            let annotation = IdentifiableMapAnnotation()
            annotation.location = location
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(location.latitude),
                longitude: CLLocationDegrees(location.longitude)
            )
            annotations.append(annotation)
        }
        uiView.addAnnotations(annotations)
    }
    
    func addLongPressGesture(_ uiView: MKMapView, context: Context) {
        let longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.addTarget(context.coordinator, action: #selector(context.coordinator.onLongPressOnMap(_:)))
        uiView.addGestureRecognizer(longPressRecognizer)
    }
}

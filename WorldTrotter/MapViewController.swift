//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by MJC-iCloud on 2/18/19.
//  Copyright © 2019 Matthew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite", "ZOOM"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = MKMapType.hybrid
        case 2:
            mapView.mapType = MKMapType.satellite
        case 3:
            zoomToCurrentLocation()
        default:
            break
        }
    }
    
    func zoomToCurrentLocation() {
        // Based on Shobhakar Tiwari's code here:
        // stackoverflow.com/questions/41189147/mapkit-zoom-to-user-current-location
        print("about to zoom.")
        locationManager.startUpdatingLocation()
        print("startUpdatingLocation called.")
        //startReceivingLocationChanges()
        if let currentLocation = locationManager.location {
            print("got latitude: \(String(describing: locationManager.location?.coordinate.latitude))")
            let currentCoord = currentLocation.coordinate

            let currentLocationViewRegion = MKCoordinateRegion.init(center: currentCoord, latitudinalMeters: 50000, longitudinalMeters: 50000)
            mapView.setRegion(currentLocationViewRegion, animated: true)
            print("zoomed.")
        } else {
            print("locationManager.location is NIL")
        }
        
    // This next line was shutting down locationManager PERMANENTLY;
    // The call to "startUpdatingLocation()" at the begining of this func
    // would then have no effect, and "locationManager.location" would always be nil
        //locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Map loaded.")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            print("authorized")
        } else {
            print("NOT authorized")
        }
    }
    
    func startReceivingLocationChanges() {
        // This func is basically taken from the Apple documentation.
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse {
            print("startReceiving... NOT authorized")
            return
        }
        if !CLLocationManager.locationServicesEnabled() {
            print("location services NOT enabled")
            return
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // probably the most critical line of this function.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // This code is from:
        // cs-courses.mines.edu/csci498b_fall2016/lectures/14/CoreLocationMapKitNotes.pdf
        let clError = error as! CLError
        var errorType = String()
        
        switch clError.code {
        case .denied:
            errorType = "Location service denied."
        case .locationUnknown:
            errorType = "Location can't be determined."
        default:
            errorType = error.localizedDescription
        }
        
        let alert = UIAlertController(title: "Location access error", message: errorType, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

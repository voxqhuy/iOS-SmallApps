//
//  MapViewController.swift
//  Temperature-Conversion
//
//  Created by Vo Huy on 5/9/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    var mapView: MKMapView!
    var userLocationBtn: UIButton!
    var locationManager: CLLocationManager?
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager = CLLocationManager()
        
        // Set it as the view of this view controller
        view = mapView
        
        // add a segmented control
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        // the map view's constraints
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        // add margins
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // setting up the user location button
        addUserLocationBtn()
    }
    
    override func viewDidLoad() {
        print("running map")
    }
    
    // MARK: Private methods
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func addUserLocationBtn() {
//        userLocationBtn = UIButton(frame: CGRect(x: 24, y: 120, width: 120, height: 48))
        userLocationBtn = UIButton.init(type: .system)
        userLocationBtn.setTitle("Your location", for: .normal)
        userLocationBtn.translatesAutoresizingMaskIntoConstraints = false
        userLocationBtn.addTarget(self, action: #selector(MapViewController.toUserLocation(sender:)), for: .touchUpInside)
        self.view.addSubview(userLocationBtn)
        
        // the button's constraints
        let topBtnConstraint = userLocationBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let leadingBtnConstraint = userLocationBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingBtnConstraint = userLocationBtn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topBtnConstraint.isActive = true
        leadingBtnConstraint.isActive = true
        trailingBtnConstraint.isActive = true
    }
    
    // a handler for user location button => go to the user's location
    @objc func toUserLocation(sender: UIButton!) {
        locationManager?.requestWhenInUseAuthorization()
        //fire up the method mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
        mapView.showsUserLocation = true 
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
}

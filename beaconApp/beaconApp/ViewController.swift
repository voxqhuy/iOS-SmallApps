//
//  ViewController.swift
//  beaconApp
//
//  Created by Vo Huy on 6/27/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    var locationManager: CLLocationManager!
    
    
    @IBOutlet var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
        
        
        view.backgroundColor = UIColor.gray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status.rawValue)
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
}


// MARK: - Beacon helpers
extension ViewController {
    func startScanning() {
        let uuid = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: "MyBeacon")
        
        let uuid1 = UUID(uuidString: "067C10EA-448B-4643-928E-242DB4321263")!
        let beaconRegion1 = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 10, identifier: "MyBeacon1")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
        locationManager.startMonitoring(for: beaconRegion1)
        locationManager.startRangingBeacons(in: beaconRegion1)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
//            [self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
}

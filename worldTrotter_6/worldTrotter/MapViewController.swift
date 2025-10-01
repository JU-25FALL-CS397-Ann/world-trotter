//
//  MapViewController.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/27/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        
        // Set it as *the* view of this view controller
        view = mapView
        
        // Bronze Challenge: Add segmented control for map type
        let segmentedControl = UISegmentedControl(items: ["Standard", "Satellite", "Hybrid"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        
        // Bronze Challenge: Add a label and switch for Points of Interest
        let POILabel = UILabel()
        POILabel.text = "Points of Interest"
        POILabel.translatesAutoresizingMaskIntoConstraints = false
        
        let POISwitch = UISwitch()
        POISwitch.isOn = true
        POISwitch.translatesAutoresizingMaskIntoConstraints = false
        POISwitch.addTarget(self, action: #selector(togglePOI(_:)), for: .valueChanged)
        
        view.addSubview(POILabel)
        view.addSubview(POISwitch)
        
        // Bronze Challenge: Constraints for POI controls
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            POILabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            POILabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            POISwitch.centerYAnchor.constraint(equalTo: POILabel.centerYAnchor),
            POISwitch.leadingAnchor.constraint(equalTo: POILabel.trailingAnchor, constant: 8)
        ])
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        checkLocationPermissions()
    }
    
    // MARK: - Silver Challenge: Displaying the User's Region
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationPermissions() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            print("Location access denied")
        @unknown default:
            break
        }
    }
    
    private func startLocationUpdates() {
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Map Controls Actions
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    // MARK: - Bronze Challenge: Toggle Points of Interest
    @objc func togglePOI(_ sender: UISwitch) {
        let POIFilter: MKPointOfInterestFilter = sender.isOn ? .includingAll : .excludingAll
        mapView.pointOfInterestFilter = POIFilter
    }
    
    // MARK: - CLLocationManagerDelegate (Silver Challenge)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Set the map region to show the user's area
        let region = MKCoordinateRegion(center: location.coordinate,
                                      latitudinalMeters: 10000,
                                      longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        // Stop updating location to avoid constant updates
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermissions()
    }
}
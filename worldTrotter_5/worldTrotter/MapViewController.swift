//
//  MapViewController.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/27/25.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    // MARK: - Views
    private var mapView: MKMapView!
    private var segmentedControl: UISegmentedControl!
    private var poiLabel: UILabel!
    private var poiSwitch: UISwitch!

    // MARK: - Lifecycle
    override func loadView() {
        // Root view is the map
        mapView = MKMapView(frame: .zero)
        view = mapView

        // Segmented control for map type
        segmentedControl = UISegmentedControl(items: ["Standard", "Satellite", "Hybrid"])
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)

        // Bronze challenge: label + switch for Points of Interest
        poiLabel = UILabel()
        poiLabel.text = "Points of Interest"
        poiLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        poiSwitch = UISwitch()
        poiSwitch.isOn = true
        poiSwitch.addTarget(self, action: #selector(togglePOI(_:)), for: .valueChanged)

        // Turn off autoresizing mask translation for programmatic constraints
        [segmentedControl, poiLabel, poiSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        // Layout
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            // Segmented control pinned to top, inset by safe area
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            // POI row under the segmented control
            poiLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            poiLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),

            poiSwitch.centerYAnchor.constraint(equalTo: poiLabel.centerYAnchor),
            poiSwitch.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        // Ensure initial map type and POI filter match UI
        mapView.mapType = .standard
        mapView.pointOfInterestFilter = .includingAll
    }

    // MARK: - Actions
    @objc private func mapTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .satellite
        case 2: mapView.mapType = .hybrid
        default: break
        }
    }

    @objc private func togglePOI(_ sender: UISwitch) {
        mapView.pointOfInterestFilter = sender.isOn ? .includingAll : .excludingAll
    }
}
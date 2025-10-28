//
//  MapViewController.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 28.10.2025.
//

import UIKit
import MapKit
import Combine

final class MapViewController: BaseViewController {

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private let viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupBindings() {
        viewModel.handleLoadState = { [weak self] state in
            self?.handleLoadState(state: state)
        }
        
        viewModel.updateOwnLocation = { [weak self] location in
            self?.updateOwnLocation(location)
        }
    }
    
    override func setupUI() {
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        if #available(iOS 26, *) {
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        } else {
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }

    private func handleLoadState(state: StationRepository.LoadState) {
        switch state {
        case .loaded(let stations):
            logger.info(.init(stringLiteral: "Number of stations: \(stations.count)"))
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(stations)
        case .failed:
            logger.error(.init(stringLiteral: "Failed to load static data"))
        default: break
        }
    }

    private func updateOwnLocation(_ location: CLLocation) {
        // Center map on user's location (1km radius) ~1km
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )

        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        guard let station = annotation as? UniqueStation else { return nil }

        let identifier = "StationAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier
        ) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(
                annotation: station,
                reuseIdentifier: identifier
            )
            annotationView?.canShowCallout = true

            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = station
        }

        annotationView?.glyphImage = UIImage(systemName: "ev.charger")
        annotationView?.markerTintColor = station.availability.tintColor

        return annotationView
    }
}

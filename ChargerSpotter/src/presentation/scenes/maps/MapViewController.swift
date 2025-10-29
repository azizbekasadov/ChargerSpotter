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
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "StationCluster")
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "StationAnnotation")
        
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
        if annotation is MKUserLocation { return nil }
        
        // Clustering
        if let cluster = annotation as? MKClusterAnnotation {
            let id = "StationCluster"
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: id, for: cluster) as! MKMarkerAnnotationView
            
            view.canShowCallout = true
            view.animatesWhenAdded = true
            view.subtitleVisibility = .adaptive
            view.clusteringIdentifier = nil
            view.displayPriority = .defaultHigh
            
            let count = cluster.memberAnnotations.count
            view.glyphText = "\(count)"
            view.markerTintColor = dominantTintColor(for: cluster)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
        }
        
        guard let station = annotation as? UniqueStation else { return nil }
        
        let id = "StationAnnotation"
        let view = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView)
        ?? MKMarkerAnnotationView(annotation: station, reuseIdentifier: id)
        
        view.annotation = station
        view.canShowCallout = true
        view.glyphImage = UIImage(systemName: "ev.charger")
        view.markerTintColor = station.availability.tintColor
        
        view.clusteringIdentifier = "station"
        view.displayPriority = .defaultLow
        
        if view.rightCalloutAccessoryView == nil {
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
    
    private func dominantTintColor(for cluster: MKClusterAnnotation) -> UIColor {
        var histogram: [UIColor:Int] = [:] // dynamic lookup
        
        for case let s as UniqueStation in cluster.memberAnnotations {
            let c = s.availability.tintColor
            histogram[c, default: 0] += 1
        }
        
        if let (color, _) = histogram.max(by: { $0.value < $1.value }) {
            return color
        }
        
        return .systemGray
    }
}

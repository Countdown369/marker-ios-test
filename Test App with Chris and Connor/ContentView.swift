//
//  ContentView.swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 4/11/23.
//

import SwiftUI
import MapboxMaps

class ViewController: UIViewController {
 
    internal var mapView: MapView!
 
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            // Handle missing or invalid access token
            return
        }
        let myResourceOptions = ResourceOptions(accessToken: accessToken)
        let myCameraOptions = CameraOptions(center:CLLocationCoordinate2DMake(40.73585, -73.97496))
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: myCameraOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 
        self.view.addSubview(mapView)
        
        let customCoordinate = CLLocationCoordinate2DMake(40.73585, -73.97496)
        var pointAnnotation = PointAnnotation(coordinate: customCoordinate)
        
        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
            let fileName = "water-fountains"
            
            guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
                preconditionFailure("File '\(fileName)' not found.")
            }
            let filePath = URL(fileURLWithPath: path)
            
            
            var featureCollection: FeatureCollection!
            do {
                let data = try Data(contentsOf: filePath)
                featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
            } catch {
                print("Error parsing data: \(error)")
            }
            
            // Create a GeoJSON data source.
            var geoJSONSource = GeoJSONSource()
            geoJSONSource.data = .featureCollection(featureCollection)
            
            let geoJSONDataSourceIdentifier = "water-fountains"
            
            var circleWaterFountainsLayer = CircleLayer(id: "circle-water-fountains")
            circleWaterFountainsLayer.source = geoJSONDataSourceIdentifier
            
            circleWaterFountainsLayer.circleRadius = .constant(8)
            circleWaterFountainsLayer.circleColor = .constant(StyleColor(.red))
            
            // Add the source and style layer to the map style.
            try! self.mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
            try! self.mapView.mapboxMap.style.addLayer(circleWaterFountainsLayer, layerPosition: nil)
        }

        // Make the annotation show a red pin
        pointAnnotation.image = .init(image: UIImage(named: "map-marker")!, name: "map-marker")
        pointAnnotation.iconAnchor = .bottom

        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()

        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager.annotations = [pointAnnotation]
    }
    
}

//
//  ContentView.swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 4/11/23.
//

import MapboxMaps

final class MapViewController: UIViewController {
    
    internal var mapView: MapView!
    internal var scrollView: UIScrollView!
    internal var textView: UILabel!
    
    // variable to store the geojson data
    var FC: FeatureCollection!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the map
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            // Handle missing or invalid access token
            return
        }
        let myResourceOptions = ResourceOptions(accessToken: accessToken)
        let myCameraOptions = CameraOptions(center:CLLocationCoordinate2DMake(40.73585, -73.97496), zoom:10)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: myCameraOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        do {
            try mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(minZoom: 1.0))
        } catch {
            print("Error setting min zoom: \(error)")
        }
        
        self.view.addSubview(mapView)
        
        
        // add source and layer on map load
        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
            print("DOODOO", self.mapView.mapboxMap.style.allLayerIdentifiers)
            // Create a GeoJSON data source.
            var geoJSONSource = GeoJSONSource()
            geoJSONSource.data = .featureCollection(self.FC!)
            
            let geoJSONDataSourceIdentifier = "water-fountains"

            // Create a circle layer
            var circleWaterFountainsLayer = CircleLayer(id: "circle-water-fountains")
            circleWaterFountainsLayer.source = geoJSONDataSourceIdentifier

            circleWaterFountainsLayer.circleRadius = .constant(4)
            circleWaterFountainsLayer.circleColor = .constant(StyleColor(.systemBlue))
            
            // Add the source and style layer to the map style.
            try! self.mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
            try! self.mapView.mapboxMap.style.addLayer(circleWaterFountainsLayer, layerPosition: nil)
        }
    }
}

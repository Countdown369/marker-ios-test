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
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 
        self.view.addSubview(mapView)
        
        let customCoordinate = CLLocationCoordinate2DMake(40.73585, -73.97496)
        var pointAnnotation = PointAnnotation(coordinate: customCoordinate)

        // Make the annotation show a red pin
        pointAnnotation.image = .init(image: UIImage(named: "map-marker")!, name: "map-marker")
        pointAnnotation.iconSize = 0.05
        pointAnnotation.iconAnchor = .bottom

        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()

        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager.annotations = [pointAnnotation]
    }
    
}

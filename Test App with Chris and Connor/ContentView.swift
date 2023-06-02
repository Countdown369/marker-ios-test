//
//  ContentView.swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 4/11/23.
//

import MapboxMaps

final class ViewController: UIViewController {
    
    internal var mapView: MapView!
    internal var scrollView: UIScrollView!
    internal var textView: UILabel!
    
    var mapDraggingSubscription: MapboxMaps.Cancelable?
    var draggingRefreshTimer: Timer?
    
    
    func reloadResultsOnCameraChange(_ event: MapEvent<NoPayload>) {
        print("I'm starting")
        draggingRefreshTimer?.invalidate()
        draggingRefreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reloadResultInMapBounds), userInfo: nil, repeats: false)
    }
    
    @objc
    func reloadResultInMapBounds() {
        let cameraOptions = CameraOptions(cameraState: mapView.mapboxMap.cameraState, anchor: nil)
        let cameraBounds = mapView.mapboxMap.coordinateBounds(for: cameraOptions)
        print(cameraBounds.southwest)
        print(cameraBounds.northeast)
    }
    
    override public func viewDidLoad() {
        print("Hi mom!")
        super.viewDidLoad()
        
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            // Handle missing or invalid access token
            return
        }
        let myResourceOptions = ResourceOptions(accessToken: accessToken)
        let myCameraOptions = CameraOptions(center:CLLocationCoordinate2DMake(40.73585, -73.97496), zoom:14)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, cameraOptions: myCameraOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        do {
            try mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(minZoom: 14.0))
        } catch {
            print("Error setting min zoom: \(error)")
        }
        
        self.view.addSubview(mapView)
        
        let viewHeight = view.frame.size.height //grabs the height of your view
        let viewLayout = UICollectionViewFlowLayout()
        scrollView = UICollectionView(frame: view.bounds, collectionViewLayout: viewLayout)
        scrollView.backgroundColor = UIColor.yellow.withAlphaComponent(0.75)
        scrollView.frame = CGRect(x: 0, y: viewHeight - 200, width: self.view.frame.width, height: 200)
        
        self.view.addSubview(scrollView)
        
        let numbers = ["Connor", "Chris", "New York", "Boston"]
        for (index, thing) in numbers.enumerated(){
            textView = UILabel(frame: CGRect(x: 300 * index, y: 0, width: Int(self.scrollView.frame.width), height: Int(self.scrollView.frame.height)))
            textView.text = thing
            scrollView.addSubview(textView)
        }
                    
//        textView = UITextView(frame: scrollView.bounds)
//        textView.text = "The UITextView"
//
//        scrollView.addSubview(textView)
        
        let customCoordinate = CLLocationCoordinate2DMake(40.73585, -73.97496)
        var pointAnnotation = PointAnnotation(coordinate: customCoordinate)
        
//        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
//            let fileName = "water-fountains"
//
//            guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
//                preconditionFailure("File '\(fileName)' not found.")
//            }
//            let filePath = URL(fileURLWithPath: path)
//
//
//            var featureCollection: FeatureCollection!
//            do {
//                let data = try Data(contentsOf: filePath)
//                featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
//            } catch {
//                print("Error parsing data: \(error)")
//            }
//
//            // Create a GeoJSON data source.
//            var geoJSONSource = GeoJSONSource()
//            geoJSONSource.data = .featureCollection(featureCollection)
//
//            let geoJSONDataSourceIdentifier = "water-fountains"
//
//            var circleWaterFountainsLayer = CircleLayer(id: "circle-water-fountains")
//            circleWaterFountainsLayer.source = geoJSONDataSourceIdentifier
//
//            circleWaterFountainsLayer.circleRadius = .constant(8)
//            circleWaterFountainsLayer.circleColor = .constant(StyleColor(.red))
//
//            // Add the source and style layer to the map style.
//            try! self.mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
//            try! self.mapView.mapboxMap.style.addLayer(circleWaterFountainsLayer, layerPosition: nil)
//
//        }
        
        // Make the annotation show a red pin
        pointAnnotation.image = .init(image: UIImage(named: "map-marker")!, name: "map-marker")
        pointAnnotation.iconAnchor = .bottom
        
        // Create the `PointAnnotationManager` which will be responsible for handling this annotation
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        
        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager.annotations = [pointAnnotation]
        
        mapDraggingSubscription = mapView.mapboxMap.onEvery(event: .cameraChanged, handler: reloadResultsOnCameraChange(_:))
        
        
    }
    
}

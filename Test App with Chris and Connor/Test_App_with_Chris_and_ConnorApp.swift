//
//  Test_App_with_Chris_and_ConnorApp.swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 4/11/23.
//

import SwiftUI
import Turf

// UIViewControllerRepresentable converts the UIViewController into a proper SwiftUI View
struct MapViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var FC: FeatureCollection!

    func makeUIViewController(context: Context) -> MapViewController {
        MapViewController()
    }
    
    func updateUIViewController(_ mapViewController: MapViewController, context: Context) {
        mapViewController.FC = FC
    }
}

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State var featureCollection: FeatureCollection!
    

    var body: some View {
        ZStack {
            MapViewControllerWrapper(FC: $featureCollection);
            LoopyCarousel();
        }
        .onAppear {
            // load geojson file and store it in the variable `featureCollection`
            let fileName = "water-fountains"
            
            guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
                preconditionFailure("File '\(fileName)' not found.")
            }
            let filePath = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: filePath)
                featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
            } catch {
                print("Error parsing data: \(error)")
            }
        }
    }
}

@main
struct Test_App_with_Chris_and_ConnorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

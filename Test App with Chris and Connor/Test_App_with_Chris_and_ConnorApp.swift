//
//  Test_App_with_Chris_and_ConnorApp.swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 4/11/23.
//

import SwiftUI
import Turf


struct MapViewControllerWrapper: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
}

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State var featureCollection: FeatureCollection!

    var body: some View {
        ZStack {
            MapViewControllerWrapper(featureCollection: featureCollection);
            LoopyCarousel();
        }
        .onAppear {
            let fileName = "water-fountains"
            
            guard let path = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
                preconditionFailure("File '\(fileName)' not found.")
            }
            let filePath = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: filePath)
                featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
                print(featureCollection.features[0]);
                print("FOO")
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

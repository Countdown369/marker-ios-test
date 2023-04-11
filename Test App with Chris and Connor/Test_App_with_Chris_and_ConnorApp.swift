//
//  Test_App_with_Chris_and_ConnorApp.swift
//  Test App with Chris and Connor
//
//  Created by Connor Brown on 4/11/23.
//

import SwiftUI

struct MapViewControllerWrapper: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
}

@main
struct Test_App_with_Chris_and_ConnorApp: App {
    var body: some Scene {
        WindowGroup {
            MapViewControllerWrapper()
        }
    }
}

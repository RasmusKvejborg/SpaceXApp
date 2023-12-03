//
//  LauncPadView.swift
//  SpaceX
//
//  Created by dmu mac 27 on 30/11/2023.
//

import SwiftUI
import MapKit



struct LaunchPadsView: View {
    @State private var mapSelection: Int?
    @EnvironmentObject var stateController: StateController
    @State private var cameraPosition: MapCameraPosition = .cameraInit
    @State private var selectedLaunchPad: String?

    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection){
            Marker("Vandenberg Launchpad", coordinate: MapCameraPosition.vandenberg3W.camera!.centerCoordinate).tag(1)

            Marker("vandenberg4E Launchpad", coordinate: MapCameraPosition.vandenberg4E.camera!.centerCoordinate).tag(2)
            
            Marker("capeCanaveral40 Launchpad", coordinate: MapCameraPosition.capeCanaveral40.camera!.centerCoordinate).tag(3)
            
            Marker("capeCanaveral39A Launchpad", coordinate: MapCameraPosition.capeCanaveral39A.camera!.centerCoordinate).tag(4)
            
            Marker("bocaChica Launchpad", coordinate: MapCameraPosition.bocaChica.camera!.centerCoordinate).tag(5)
            
            Marker("kwajaleinOmelek Launchpad", coordinate: MapCameraPosition.kwajaleinOmelek.camera!.centerCoordinate).tag(6)
                
        }
    }
}


extension MapCameraPosition {
    static var cameraInit = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 25, longitude: -100),
            distance: 20000000 // har sat en høj distance for at kunne se flest mulige launchpads ved init
        ))
    
    static var vandenberg3W = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 34.6440904, longitude: -120.5931438),
            distance: 400,
            heading: 160,
            pitch: 60
        ))
    
    static var vandenberg4E = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 34.632093
, longitude: -120.610829),
            distance: 400,
            heading: 160,
            pitch: 60
        ))
    
    static var capeCanaveral40 = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 28.5618571, longitude: -80.577366),
            distance: 400,
            heading: 160,
            pitch: 60
        ))
    
    static var capeCanaveral39A = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 28.6080585, longitude: -80.6039558),
            distance: 400,
            heading: 160,
            pitch: 60
        ))
    
    static var bocaChica = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 25.9972641, longitude: -97.1560845),
            distance: 400,
            heading: 160,
            pitch: 60
        ))
    
    static var kwajaleinOmelek = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 9.0477206, longitude: 167.7431292),
            distance: 400,
            heading: 160,
            pitch: 60
        ))
}







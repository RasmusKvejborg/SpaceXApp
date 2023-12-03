//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by dmu mac 27 on 29/11/2023.
//

import SwiftUI

@main
struct SpaceXApp: App {
    
    @StateObject private var stateController = StateController()
    
    var body: some Scene {
        WindowGroup {

            
            
            TabView {
                NavigationView {
                    LaunchListView().environmentObject(stateController)
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Launches")
                }
                NavigationView {
                    LaunchPadsView().environmentObject(stateController).tabItem { Image(systemName: "map")
                        Text("Launch sites") }
                }
                
                SavedLaunchesView().environmentObject(stateController).tabItem { Image(systemName: "star")
                    Text("Saved") }
                

                
                
            } // tabview slut
            
            
            //-------------------
        }
    }
}

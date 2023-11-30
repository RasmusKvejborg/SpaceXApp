//
//  SavedLaunchesView.swift
//  SpaceX
//
//  Created by dmu mac 27 on 30/11/2023.
//

import SwiftUI


struct SavedLaunchesView: View {
    
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        VStack {
            Text("hejsaa")
            
            List {
                ForEach(stateController.savedLaunches ) { launch in
                    Text(launch.name)
                }
            }
        }
    }
        
    }

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
            
            List {
                
                ForEach(stateController.savedLaunches, id: \.self) { launch in // tilføjer et Id for at gøre [String] identifiable, da det ikke er selve launchobjektet der er gemt, men blot ID'et
                    LaunchDetailsView(launchID: launch) // har et view nedenfor der henter navnene på hver ting i listen
                }
            }
        }
        
    }
}
    
    struct LaunchDetailsView: View {
        @State private var launch: Launch? = nil // laver en optional Launch ligesom i details viewet

        let launchID: String
        
        var body: some View {
            VStack {
                
                if let launchName = launch?.name {
                    Text(launchName) // viser navnet hvis det findes ud fra id'et
                }
                else {
                    ProgressView()
                }
            }
            .onAppear {
                fetchLaunch(from: launchID) // onappear fik jeg det til at lykkes med her, hvor jeg tidligere har brugt task ovre i details view
            }
        }
        
        private func fetchLaunch(from launchId: String){ // denne funktion er den samme som fetchRocket inde i StateController
            guard let launchURL = URL(string: "https://api.spacexdata.com/v5/launches/" + launchId) else {return}
            Task(priority: .low) {
                guard let rawData = await NetworkService.getData(from: launchURL) else { return }
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(Launch.self, from: rawData)
                    self.launch = result
                } catch {
                    fatalError("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        
        
        
        
    }


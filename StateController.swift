//
//  StateController.swift//
//

import SwiftUI


class StateController: ObservableObject {
    @Published var launches: [Launch] = [] // laver en tom liste
    @Published var savedLaunches: [String] = [] // skal iflg. opgaven ikke gemme objektet men blot ID'et
    @Published var rocket: Rocket?
    @Published var launchpad: Launchpad?



    
    init(){
        guard let dataUrl  = URL(string: "https://api.spacexdata.com/v5/launches") else {return}
        Task {
            await fetchAndSortLaunches(from: dataUrl) // skal lige awaites og ind i en asynkron task pga. mainActor
        }
        fetchSavedLaunches()
    }
    

    
    @MainActor // mainActor sørger for at funktionen kører på main tråden.
    private func fetchAndSortLaunches(from url: URL) {
        Task(priority: .low) {
            guard let rawData = await NetworkService.getData(from: url) else { return }
            let decoder = JSONDecoder()
            do{ // samme som try
                var launchResult = try decoder.decode([Launch].self, from: rawData)
                launchResult.sort { launch1, launch2 in // sorterer dato faldende
                    launch1.date_utc > launch2.date_utc
                }
                self.launches = launchResult // fylder den tomme liste med det data, som er fundet i URL'en
            } catch { // fejlhåndtering
                fatalError("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
    private func fetchSavedLaunches(){ // henter
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("savedLaunchIds.json")
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let loadedLaunches = try decoder.decode([String].self, from: data)
                savedLaunches = loadedLaunches
            } catch {
                print("Error loading data: \(error)")
                savedLaunches = []
            }
        } else {
            savedLaunches = []
        }
    }
    
    
    
    
    
    
    
    

    private func fetchLaunches(from url: URL) {
        Task(priority: .low){
            guard let rawData = await NetworkService.getData(from: url) else {return}
            let decoder = JSONDecoder()
            do {
                let launchResult = try decoder.decode([Launch].self, from: rawData)
                Task.detached { @MainActor in
                    self.launches = launchResult // fylder den tomme liste med det data, som er fundet i URL'en
                }
               
            } catch { // fejlhåndtering
                fatalError("Konverteringen fra JSON gik dårligt: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRocket(from rocketId: String){
        guard let rocketURL = URL(string: "https://api.spacexdata.com/v4/rockets/" + rocketId) else {return} // launch.rocket er ID'et på rocket.

        
        Task(priority: .low) {
            guard let rawData = await NetworkService.getData(from: rocketURL) else { return }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(Rocket.self, from: rawData) 
                self.rocket = result
            } catch { // fejlhåndtering
                fatalError("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchLaunchpad(from launchpadId: String){
        
        guard let url = URL(string: "https://api.spacexdata.com/v4/launchpads/" + launchpadId) else {return} // caster strengen til URL
        Task(priority: .low) {
                    guard let rawData = await NetworkService.getData(from: url) else { return }
                    let decoder = JSONDecoder()
                    do{
                        let result = try decoder.decode(Launchpad.self, from: rawData) //[Launch] hvis flere?
                        self.launchpad = result
                    } catch { // fejlhåndtering
                        fatalError("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    }
    
    
    
}

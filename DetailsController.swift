//
//  StateController.swift//
//

import SwiftUI

class DetailsController: ObservableObject {
//    @Published var launches: [Launch] = [] // laver en tom liste
    
    init(){
        guard let dataUrl  = URL(string: "https://api.spacexdata.com/v5/launches") else {return}
//        fetchLaunches(from: dataUrl)
        Task {
            await fetchAndSortLaunches(from: dataUrl) // skal lige awaites og ind i en task pga. mainActor
        }
    }
    

    
    @MainActor // mainActor sørger for at funktionen kører på main tråden.
    private func fetchAndSortLaunches(from url: URL) {
        Task(priority: .low) {
            guard let rawData = await NetworkService.getData(from: url) else { return }
            let decoder = JSONDecoder()
            do{ // samme som try
                var launchResult = try decoder.decode([Launch].self, from: rawData)
                launchResult.sort { launch1, launch2 in
                    launch1.date_utc > launch2.date_utc
                }
                self.launches = launchResult // fylder den tomme liste med det data, som er fundet i URL'en
            } catch { // fejlhåndtering
                fatalError("Error decoding JSON: \(error.localizedDescription)")
            }
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
}

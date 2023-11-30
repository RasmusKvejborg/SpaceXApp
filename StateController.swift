//
//  StateController.swift//
//

import SwiftUI

class StateController: ObservableObject {
    @Published var launches: [Launch] = [] // laver en tom liste
    @Published var savedLaunches: [Launch] = []

    
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
                launchResult.sort { launch1, launch2 in
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
            let fileURL = documentsDirectory.appendingPathComponent("savedLaunches.json")
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let loadedLaunches = try decoder.decode([Launch].self, from: data)
                savedLaunches = loadedLaunches
            } catch {
                print("Error loading data: \(error)")
                savedLaunches = []
            }
        } else {
            savedLaunches = []
        }
    }
    
    
//    private func fetchSavedLaunches() {
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            savedLaunches = []
//            return
//        }
//
//        let fileURL = documentsDirectory.appendingPathComponent("savedLaunches.json")
//
//        do {
//            let data = try Data(contentsOf: fileURL)
//            let decoder = JSONDecoder()
//
//            if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
//                // Handle array scenario
//                let loadedTodoItems = try decoder.decode([Launch].self, from: data)
//                savedLaunches = loadedTodoItems
//            } else {
//                print("JSON data is not an array of objects.")
//                savedLaunches = []
//            }
//        } catch {
//            print("Error loading data: \(error)")
//            savedLaunches = []
//        }
//    }
    
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

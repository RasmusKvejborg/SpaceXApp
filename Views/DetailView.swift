
import SwiftUI

struct DetailView: View {
    @Binding var launch: Launch // laver en binding så objektet sendes videre in detaljesiden
    @EnvironmentObject var stateController: StateController
    @State private var isSaved = false
    @State private var message = ""

    
    
    
 
    
    var body: some View {
        VStack(){

            if let imageURL = launch.links.patch.small { // kopieret min kode fra listView
                           AsyncImage(url: imageURL) { image in
                               AvatarView(image: image)
                           } placeholder: {
                               ProgressView()
                           }
                       } else {
                           PlaceholderView() } // har lavet en placeholder med et raket billede i assets, som vises hvis ikke der findes et billede i JSON
            Text(launch.name).font(.title).padding()

            Text("rocket, capsules, launchpad, crew og payloads")
            Text(launch.rocket)
            Text(launch.launchpad).padding()
            // capsules og crew og payloads skal kun vises hvis de findes.
            
//            // capsules er en liste, så skal læses for hver...
            /*Text(launch.crew)*/ // crew er også en liste...
            
            Button(action: {
                if isSaved {
                     removeLaunch()
                 } else {
                     stateController.savedLaunches.append(launch) // appender lige launch til listen, inden listen gemmes igen
                     saveLaunch() // hvis isSaved er false når den trykkes på, så skal den blive true og gemme saveLaunch
                 }
                           isSaved.toggle() // sætter isSaved til at være !isSaved dvs. true hvis den er false og omvendt
                
                       }) {
                           Image(systemName: isSaved ? "star.fill" : "star") // ternary operator der ændrer stjernens udseende baseret på om isSaved er true eller false
                               .foregroundColor(isSaved ? .yellow : .blue)
                               .font(.title)
                       }
                   }
                   .padding()
        // skal huske at tjekke om den findes i savedLaunches og i så fald lade den være isSaved = true:
                   .onAppear {
                       isSaved = stateController.savedLaunches.contains { savedLaunch in
                           savedLaunch.id == launch.id
                       }
                   }
        
        Text(message) // viser ingenting i starten, tom streng. I stedet for en alert eller lignende.
        
    }


func saveLaunch(){
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(stateController.savedLaunches) //kræver at Launch er encodable

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("savedLaunches.json")

            try data.write(to: fileURL)
            print("Data saved to: \(fileURL)")
            message = "Launch saved" // lader brugeren vide, at launchen er gemt
        }
    } catch {
        print("Error saving data: \(error)")
        message = "Error"
    }
    
}

func removeLaunch(){
    message = "Launch removed from saved list"
//    stateController.savedLaunches.removeAll { $0.id == launch.id }
    if let index = stateController.savedLaunches.firstIndex(where: { savedLaunch in
        savedLaunch.id == launch.id
    }) {
        stateController.savedLaunches.remove(at: index)
    }
    // hernede bør den lige gemme listen igen, efter at launchen er fjernet fra listen:
    saveLaunch()
}
    
}



struct PlaceholderView: View {
    var body: some View {
        Image("RocketImage")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .shadow(radius: 7)
            .frame(width: 80, height: 80)
    }
}

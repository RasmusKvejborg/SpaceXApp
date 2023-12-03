
import SwiftUI

struct DetailView: View {
    @Binding var launch: Launch // laver en binding så objektet sendes videre ind i detaljesiden
    @EnvironmentObject var stateController: StateController
    @State private var isSaved = false
    @State private var message = ""
    @State private var rocket: Rocket? = nil
    @State private var launchpad: Launchpad? = nil


    
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

//            Text("Mangler at vise capsules, launchpad, crew og payloads")

            if let rocketName = stateController.rocket?.name {
                Text("Rocket name: "+rocketName).padding()
            }
            if let launchPadName = stateController.launchpad?.full_name {
                Text("Launchpad name: "+launchPadName).padding()
            }
            
            Button(action: {
                if isSaved {
                     removeLaunch()
                 } else {
                     stateController.savedLaunches.append(launch.id) // appender lige launch til listen, inden listen gemmes igen
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
                   .task { // har en task her der henter rocket data ud fra ID'et via fetchRocket
                       stateController.fetchRocket(from: launch.rocket) //
                      
                       stateController.fetchLaunchpad(from: launch.launchpad)
                            
                       }
        // skal huske at tjekke om den findes i savedLaunches og i så fald lade den være isSaved = true:
                   .onAppear {
                       isSaved = stateController.savedLaunches.contains { savedLaunch in
                           savedLaunch == launch.id
                       }
                   }
        
        Text(message) // viser ingenting i starten, tom streng. I stedet for en alert eller lignende.
        
    }
// ville gerne have lavet denne funktion generisk, så den kunne fetche enhver type <T> men har undladt pga tidsmangel.
 
    


func saveLaunch(){ // bruger FileManager til Lokal arkivering
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(stateController.savedLaunches) //kræver at Launch er encodable

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("savedLaunchIds.json")

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
    if let index = stateController.savedLaunches.firstIndex(where: { savedLaunch in // finder index'et på launchen
        savedLaunch == launch.id
    }) {
        stateController.savedLaunches.remove(at: index) // fjerner launchen fra listen via index
    }
    // hernede skal den lige gemme listen igen, efter at launchen er fjernet fra listen, så det persisterer:
    saveLaunch()
    message = "Launch removed from saved list"

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

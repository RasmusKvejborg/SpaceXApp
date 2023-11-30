

import SwiftUI

struct LaunchCellView: View {
    @Binding var launch: Launch
    
    var body: some View {
        HStack {

            if let imageURL = launch.links.patch.small {
                           AsyncImage(url: imageURL) { image in
                               AvatarView(image: image)
                           } placeholder: {
                               ProgressView()
                           }
                       } else {
                           PlaceholderView() } // har lavet en placeholder med et raket billede i assets, som vises hvis ikke der findes et billede i JSON. Jeg kunne have sat den i placeholder i linje 14, men ville gerne vise en spinner, indtil den har fundet billedet.
            
            VStack(alignment: .leading) {
                Text(launch.name)
                    .padding()
                
            if let formattedDate = formatDate(launch.date_utc) // kalder formattedDate og viser det hvis ikke formatDate har returneret nil
                                    {
                Text(formattedDate)
                    .font(.caption)
                                    }
            }
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
    
    func formatDate(_ dateString: String) -> String? { // laver en funktion der tager en string som argument og returnerer en optional string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // De bruger UTC formatet, som jeg konverterer fra
        
        if let date = dateFormatter.date(from: dateString) { // forsøger at konvertere dato-strengen
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM yyyy" // vælger at datoen skal vises med et leading zero (f.eks "03" for marts) fordi det er man vant til at se.
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }

}


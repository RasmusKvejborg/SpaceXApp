

import SwiftUI

struct LaunchesOnLocationView: View {
    
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        
            List($stateController.launches) { $launch in
                NavigationLink(destination: DetailView(launch: $launch).navigationTitle("Launch details").environmentObject(stateController)) { // skal lige videresende stateController for at kunne bruge den i details viewet
                    
                    LaunchCellView(launch: $launch)
                        .listRowSeparator(.hidden)
                }
            }
        }
    }

#Preview {
    LaunchListView().environmentObject(StateController())
}

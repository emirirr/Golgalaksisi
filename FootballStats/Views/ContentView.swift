import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MatchesViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LeaguesView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Ligler")
                }
                .tag(0)
            
            GoalKingsView()
                .tabItem {
                    Image(systemName: "soccerball")
                    Text("Gol Kralları")
                }
                .tag(1)
            
            ResultsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Sonuçlar")
                }
                .tag(2)
        }
        .accentColor(Theme.accent)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
} 

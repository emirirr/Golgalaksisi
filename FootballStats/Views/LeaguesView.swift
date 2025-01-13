import SwiftUI

struct LeaguesView: View {
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                Group {
                    if viewModel.isLoading {
                        ProgressView("Ligler yükleniyor...")
                            .foregroundColor(Theme.foreground)
                    } else if let error = viewModel.error {
                        VStack {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button("Tekrar Dene") {
                                viewModel.fetchLeagues()
                            }
                            .buttonStyle(.bordered)
                            .tint(Theme.accent)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: Theme.padding) {
                                ForEach(viewModel.leagues) { league in
                                    LeagueCard(league: league)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Ligler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Theme.background, for: .navigationBar)
            .onAppear {
                if viewModel.leagues.isEmpty {
                    viewModel.fetchLeagues()
                }
            }
        }
    }
}

struct LeagueCard: View {
    let league: League
    
    var body: some View {
        Theme.cardStyle(
            VStack(spacing: Theme.padding) {
                Text(league.name)
                    .font(.headline)
                    .foregroundColor(Theme.foreground)
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: LeagueStandingsView(league: league)) {
                    Text("Puan Durumu")
                        .font(.subheadline.bold())
                        .foregroundColor(Theme.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.accentGradient)
                        .cornerRadius(Theme.cornerRadius)
                }
            }
            .padding()
        )
    }
}

#Preview {
    LeaguesView()
} 
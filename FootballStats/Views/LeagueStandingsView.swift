import SwiftUI

struct LeagueStandingsView: View {
    let league: League
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .foregroundColor(Theme.foreground)
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        VStack(spacing: Theme.padding) {
                            // Header
                            HStack {
                                Text("Sıra")
                                    .frame(width: 40)
                                Text("Takım")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("O")
                                    .frame(width: 30)
                                Text("P")
                                    .frame(width: 30)
                            }
                            .font(.caption.bold())
                            .foregroundColor(Theme.gray300)
                            .padding(.horizontal)
                            
                            ForEach(viewModel.standings) { team in
                                StandingRow(standing: team)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(league.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchStandings(for: league.key)
        }
    }
}

struct StandingRow: View {
    let standing: Standing
    
    var rankColor: Color {
        switch standing.rank {
        case 1: return .yellow
        case 2: return Theme.gray300
        case 3: return .orange
        default: return Theme.foreground
        }
    }
    
    var body: some View {
        Theme.cardStyle(
            HStack {
                Text("\(standing.rank)")
                    .font(.headline)
                    .foregroundColor(rankColor)
                    .frame(width: 40)
                
                Text(standing.team)
                    .font(.headline)
                    .foregroundColor(Theme.foreground)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(standing.played)")
                    .foregroundColor(Theme.gray300)
                    .frame(width: 30)
                
                Text("\(standing.points)")
                    .font(.headline)
                    .foregroundColor(Theme.accent)
                    .frame(width: 30)
            }
            .padding()
        )
    }
}

#Preview {
    LeagueStandingsView(league: League(key: "super-lig", name: "Süper Lig"))
} 
import SwiftUI

struct GoalKingsView: View {
    @StateObject private var viewModel = MatchesViewModel()
    @State private var selectedLeague = "super-lig"
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                VStack {
                    Picker("Lig", selection: $selectedLeague) {
                        ForEach(viewModel.leagues) { league in
                            Text(league.name)
                                .tag(league.key)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .tint(Theme.accent)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .foregroundColor(Theme.foreground)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible())], spacing: Theme.padding) {
                                ForEach(viewModel.goalKings) { player in
                                    GoalKingCard(player: player)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Gol Kralları")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.leagues.isEmpty {
                    viewModel.fetchLeagues()
                }
                viewModel.fetchGoalKings(for: selectedLeague)
            }
            .onChange(of: selectedLeague) { newValue in
                viewModel.fetchGoalKings(for: newValue)
            }
        }
    }
}

struct GoalKingCard: View {
    let player: GoalKing
    
    var body: some View {
        Theme.cardStyle(
            HStack(spacing: Theme.padding) {
                Text("\(player.rank)")
                    .font(.title2.bold())
                    .foregroundColor(Theme.accent)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .font(.headline)
                        .foregroundColor(Theme.foreground)
                    
                    if !player.team.isEmpty {
                        Text(player.team)
                            .font(.subheadline)
                            .foregroundColor(Theme.gray300)
                    }
                }
                
                Spacer()
                
                Text("\(player.goals)")
                    .font(.title3.bold())
                    .foregroundColor(Theme.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Theme.gray100)
                    .cornerRadius(Theme.cornerRadius)
            }
            .padding()
        )
    }
} 
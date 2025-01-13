import SwiftUI

struct MatchDetailView: View {
    let match: Match
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Theme.padding) {
                    ScoreboardView(match: match)
                    
                    StatisticRow(
                        title: "Top Hakimiyeti",
                        leftValue: "\(Int(match.possession.home))%",
                        rightValue: "\(Int(match.possession.away))%"
                    )
                    
                    StatisticRow(
                        title: "Şutlar",
                        leftValue: "\(match.shots.home)",
                        rightValue: "\(match.shots.away)"
                    )
                    
                    StatisticRow(
                        title: "İsabetli Şutlar",
                        leftValue: "\(match.shotsOnTarget.home)",
                        rightValue: "\(match.shotsOnTarget.away)"
                    )
                }
                .padding()
            }
        }
        .navigationTitle("\(match.homeTeam) vs \(match.awayTeam)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatisticRow: View {
    let title: String
    let leftValue: String
    let rightValue: String
    
    var body: some View {
        Theme.cardStyle(
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Theme.gray300)
                
                HStack {
                    Text(leftValue)
                        .font(.title3.bold())
                        .foregroundColor(Theme.accent)
                    Spacer()
                    Text(rightValue)
                        .font(.title3.bold())
                        .foregroundColor(Theme.accent)
                }
                .padding(.horizontal)
            }
            .padding()
        )
    }
}

#Preview {
    MatchDetailView(match: Match(
        homeTeam: "Galatasaray",
        awayTeam: "Fenerbahçe",
        homeScore: 2,
        awayScore: 1,
        date: Date(),
        possession: (home: 55, away: 45),
        shots: (home: 15, away: 12),
        shotsOnTarget: (home: 7, away: 5)
    ))
} 
import SwiftUI

struct ScoreboardView: View {
    let match: Match
    
    var body: some View {
        Theme.cardStyle(
            VStack(spacing: Theme.padding) {
                HStack(spacing: 20) {
                    TeamScoreView(teamName: match.homeTeam, score: match.homeScore)
                    
                    Text("vs")
                        .font(.title2)
                        .foregroundColor(Theme.gray300)
                    
                    TeamScoreView(teamName: match.awayTeam, score: match.awayScore)
                }
                
                Text(match.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(Theme.gray300)
            }
            .padding()
        )
    }
}

struct TeamScoreView: View {
    let teamName: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(teamName)
                .font(.headline)
                .foregroundColor(Theme.foreground)
                .multilineTextAlignment(.center)
            
            Text("\(score)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Theme.accent)
        }
    }
}

#Preview {
    ScoreboardView(match: Match(
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

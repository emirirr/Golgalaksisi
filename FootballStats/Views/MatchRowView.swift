import SwiftUI

struct MatchRowView: View {
    let match: Match
    
    var body: some View {
        Theme.cardStyle(
            VStack(spacing: Theme.padding) {
                Text(match.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(Theme.gray300)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Theme.gray100)
                    .cornerRadius(Theme.cornerRadius)
                
                HStack(spacing: 20) {
                    TeamView(name: match.homeTeam, score: match.homeScore)
                    
                    Text("vs")
                        .font(.title3)
                        .foregroundColor(Theme.gray300)
                    
                    TeamView(name: match.awayTeam, score: match.awayScore)
                }
            }
            .padding()
        )
    }
}

struct TeamView: View {
    let name: String
    let score: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(name)
                .font(.headline)
                .foregroundColor(Theme.foreground)
                .multilineTextAlignment(.center)
            
            Text("\(score)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Theme.accent)
        }
    }
} 
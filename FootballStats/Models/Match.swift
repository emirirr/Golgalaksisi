import Foundation

struct Match: Identifiable {
    let id = UUID()
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    let date: Date
    let possession: (home: Double, away: Double)
    let shots: (home: Int, away: Int)
    let shotsOnTarget: (home: Int, away: Int)
} 
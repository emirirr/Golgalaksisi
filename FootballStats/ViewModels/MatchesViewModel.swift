import Foundation

@MainActor
class MatchesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var leagues: [League] = []
    @Published var goalKings: [GoalKing] = []
    @Published var standings: [Standing] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private func handleError(_ error: Error, for operation: String) {
        print("\(operation) Error Details:", error)
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                self.error = "Geçersiz URL"
            case .invalidResponse:
                self.error = "Sunucu yanıt vermedi"
            case .decodingError:
                self.error = "API yanıtı işlenemedi. Lütfen daha sonra tekrar deneyin."
            case .serverError(let message):
                self.error = message
            }
        } else {
            self.error = "Bir hata oluştu: \(error.localizedDescription)"
        }
    }
    
    func fetchLeagues() {
        guard leagues.isEmpty else { return }
        
        Task {
            isLoading = true
            do {
                let apiLeagues: [APILeague] = try await NetworkManager.shared.fetch("/leaguesList")
                leagues = apiLeagues.map { League(key: $0.key, name: $0.league) }
                error = nil
            } catch {
                print("Leagues Error:", error)
                handleError(error, for: "Leagues")
            }
            isLoading = false
        }
    }
    
    func fetchStandings(for leagueKey: String) {
        Task {
            isLoading = true
            error = nil
            do {
                let apiStandings: [APIStanding] = try await NetworkManager.shared.fetch("/league", queryItems: [
                    URLQueryItem(name: "data.league", value: leagueKey)
                ])
                
                standings = apiStandings.map { standing in
                    Standing(
                        rank: standing.rank,
                        team: standing.team,
                        played: standing.play,
                        points: standing.point
                    )
                }
            } catch {
                print("Standings Error:", error)
                handleError(error, for: "Standings")
            }
            isLoading = false
        }
    }
    
    func fetchResults(for leagueKey: String) {
        Task {
            isLoading = true
            error = nil
            do {
                let apiMatches: [APIMatch] = try await NetworkManager.shared.fetch("/results", queryItems: [
                    URLQueryItem(name: "data.league", value: leagueKey)
                ])
                
                matches = apiMatches.compactMap { match in
                    let scores = match.skor.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }
                    guard scores.count == 2,
                          let homeScore = Int(scores[0]),
                          let awayScore = Int(scores[1]) else {
                        return nil
                    }
                    
                    return Match(
                        homeTeam: match.home,
                        awayTeam: match.away,
                        homeScore: homeScore,
                        awayScore: awayScore,
                        date: ISO8601DateFormatter().date(from: match.date) ?? Date(),
                        possession: (home: 50, away: 50),
                        shots: (home: 0, away: 0),
                        shotsOnTarget: (home: 0, away: 0)
                    )
                }
            } catch {
                print("Results Error:", error)
                handleError(error, for: "Results")
            }
            isLoading = false
        }
    }
    
    func fetchGoalKings(for leagueKey: String) {
        Task {
            isLoading = true
            error = nil
            do {
                let apiGoalKings: [APIGoalKing] = try await NetworkManager.shared.fetch("/goalKings", queryItems: [
                    URLQueryItem(name: "data.league", value: leagueKey)
                ])
                
                goalKings = apiGoalKings.enumerated().map { index, player in
                    GoalKing(
                        rank: index + 1,
                        name: player.name,
                        team: "", // API'de takım bilgisi yok
                        goals: Int(player.goals) ?? 0
                    )
                }
            } catch {
                print("Goal Kings Error:", error)
                handleError(error, for: "GoalKings")
            }
            isLoading = false
        }
    }
}

// Date formatter extension
extension DateFormatter {
    static let matchDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy EEEE HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.timeZone = TimeZone(identifier: "Europe/Istanbul")
        return formatter
    }()
    
    static let alternateMatchDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.timeZone = TimeZone(identifier: "Europe/Istanbul")
        return formatter
    }()
}

struct GoalKing: Identifiable {
    let id = UUID()
    let rank: Int
    let name: String
    let team: String
    let goals: Int
}

struct Standing: Identifiable {
    let id = UUID()
    let rank: Int
    let team: String
    let played: Int
    let points: Int
}

func parseDate(_ dateString: String) -> Date {
    if let date = DateFormatter.matchDate.date(from: dateString) {
        return date
    }
    if let date = DateFormatter.alternateMatchDate.date(from: dateString) {
        return date
    }
    return Date()
} 
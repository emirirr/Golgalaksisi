import Foundation

// League List Response
struct APILeague: Codable {
    let league: String
    let key: String
}

// Match Result Response
struct APIMatch: Codable {
    let skor: String
    let date: String
    let away: String
    let home: String
    
    enum CodingKeys: String, CodingKey {
        case skor, date, away, home
    }
}

// League Standing Response
struct APIStanding: Codable {
    let rank: Int
    let draw: Int
    let lose: Int
    let win: Int
    let play: Int
    let point: Int
    let goalfor: Int
    let goalagainst: Int
    let goaldistance: Int
    let team: String
}

// Goal King Response
struct APIGoalKing: Codable {
    let name: String
    let goals: String
} 
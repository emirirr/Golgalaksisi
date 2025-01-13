import Foundation

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let result: T
    
    private enum CodingKeys: String, CodingKey {
        case success
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        
        do {
            result = try container.decode(T.self, forKey: .result)
        } catch {
            print("Error decoding result:", error)
            print("Result type:", String(describing: T.self))
            throw error
        }
    }
} 
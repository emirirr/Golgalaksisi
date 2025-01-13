import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.collectapi.com/sport"
    private let apiKey = Config.apiKey
    
    private init() {}
    
    private func createRequest(path: String, queryItems: [URLQueryItem]? = nil) throws -> URLRequest {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(apiKey, forHTTPHeaderField: "authorization")
        request.timeoutInterval = 30
        
        return request
    }
    
    func fetch<T: Codable>(_ path: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        let request = try createRequest(path: path, queryItems: queryItems)
        print("Requesting URL:", request.url?.absoluteString ?? "unknown")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            print("HTTP Status Code:", httpResponse.statusCode)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw API Response:")
                print(jsonString)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError("HTTP Error: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw APIError.decodingError
            }
            
            guard let success = json["success"] as? Bool, success == true else {
                throw APIError.serverError("API Error: Request was not successful")
            }
            
            do {
                let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
                return apiResponse.result
            } catch {
                print("Decoding Error:", error)
                print("Failed to decode type:", String(describing: T.self))
                throw APIError.decodingError
            }
        } catch {
            print("Network Error:", error)
            throw error
        }
    }
} 
import Foundation

enum Config {
    private static let secrets: [String: String] = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            fatalError("Secrets.plist not found")
        }
        return dict
    }()
    
    static var apiKey: String {
        guard let key = secrets["API_KEY"] else {
            fatalError("API_KEY not found in Secrets.plist")
        }
        return key
    }
} 
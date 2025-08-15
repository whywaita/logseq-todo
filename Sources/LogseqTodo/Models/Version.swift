import Foundation

struct Version {
    static var current: String {
        if let path = Bundle.main.path(forResource: "version", ofType: "txt"),
           let version = try? String(contentsOfFile: path, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines) {
            return version
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        
        return "0.1.0"
    }
}
import Foundation

// TODO: - Refactor for DI w/ protocols
class iCloudFileManager {
    static let shared = iCloudFileManager()
    private let fileManager = FileManager.default
    
    func getiCloudDocumentsURL() -> URL? {
        return fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    func listFiles(at directory: URL) -> [URL]? {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("Error listing files: \(error)")
            return nil
        }
    }
    
    func readFile(at url: URL) -> String? {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    func writeFile(at url: URL, content: String) -> Bool {
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Error writing file: \(error)")
            return false
        }
    }
}

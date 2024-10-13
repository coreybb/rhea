import UIKit

protocol FileDirectoryEntry {
    
    var name: String { get }
    var type: EntryType { get }
}


struct FileSystemItem: Hashable {
    let entry: FileDirectoryEntry
    let indentationLevel: Int
    let id = UUID()
    let path: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FileSystemItem, rhs: FileSystemItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct Directory: FileDirectoryEntry  {
    
    let type: EntryType = .folder
    private(set) var name: String
    var entries = [FileDirectoryEntry]()
    
    //  MARK: - Internal API
    mutating func addEntry(_ entry: FileDirectoryEntry) {
        entries.append(entry)
    }
    
    mutating func rename(_ newName: String) {
        name = newName
    }
    
    
    func displayEntries(indentation: String = "") {
        for entry in entries {
            print(indentation + entry.name)
            if entry is Directory {
                displayEntries(indentation: indentation + "  ")
            }
        }
    }
}


struct File: FileDirectoryEntry {
    var name: String
    let type: EntryType = .file
}


enum EntryType {
    case folder
    case file
    
    var iconImage: UIImage {
        switch self {
        case .file:
            UIImage(systemName: "swift")!
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.systemOrange)
        case .folder:
            UIImage(systemName: "folder.fill")!
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.cyan)
        }
    }
}

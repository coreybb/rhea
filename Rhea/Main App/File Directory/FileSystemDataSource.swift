import UIKit

final class FileSystemDataSource: UITableViewDiffableDataSource<FileSystemDataSource.Section, FileSystemItem> {

    enum Section {
        case main
    }

    var expandedDirectories: [String: Bool] = [:]
    weak var tableView: UITableView!
    var rootDirectory: Directory? {
        didSet {
            fileSystem = rootDirectory.map { [$0] } ?? []
        }
    }
    
    
    //  MARK: - Init
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init(tableView: tableView) { (tableView, indexPath, entry) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: FileDirectoryTableCell.reuseID, for: indexPath) as! FileDirectoryTableCell
            cell.entry = entry.entry
            cell.entryIndentationLevel = entry.indentationLevel
            return cell
        }
    }
    var fileSystem: [FileDirectoryEntry] = [] {
        didSet {
            flattenedItems = flatten(fileSystem)
        }
    }
    private var flattenedItems: [FileSystemItem] = []
    
    //  MARK: - Internal API
    
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FileSystemItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(flattenedItems, toSection: .main)
        print("Applying snapshot with \(flattenedItems.count) items")
        apply(snapshot, animatingDifferences: true)
    }
    
    
    func toggleDirectory(at indexPath: IndexPath) {
        guard let item = itemIdentifier(for: indexPath),
              item.entry.type == .folder,
              let directory = item.entry as? Directory else {
            print("Failed to toggle directory at indexPath: \(indexPath)")
            return
        }

        print("Toggling directory: \(item.path)")
        print("Directory contents: \(directory.entries.map { $0.name })")

        performToggle(for: item, directory: directory)
    }
    
    
    private func performToggle(for item: FileSystemItem, directory: Directory) {
        let isExpanded = !(expandedDirectories[item.path] ?? false)
        expandedDirectories[item.path] = isExpanded

        if isExpanded {
            expandDirectory(item, directory)
        } else {
            collapseDirectory(item)
        }
    }
    
    
    private func expandDirectory(_ item: FileSystemItem, _ directory: Directory) {
        var snapshot = snapshot()
        let newItems = createNewItems(for: directory, parentItem: item)
        
        snapshot.insertItems(newItems, afterItem: item)
        
        apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.animateExpandedCells()
        }
    }

    
    private func collapseDirectory(_ item: FileSystemItem) {
        let itemsToRemove = getItemsToRemove(for: item)
        
        itemsToRemove.forEach {
            guard let indexPath = indexPath(for: $0),
                  let cell = tableView.cellForRow(at: indexPath) as? FileDirectoryTableCell
            else {
                return
            }

            cell.animateDisappearance()
        }
        
        removeCollapsedItems(itemsToRemove)
    }
    
    
    private func createNewItems(for directory: Directory, parentItem: FileSystemItem) -> [FileSystemItem] {
        directory.entries.map {
            FileSystemItem(
                entry: $0,
                indentationLevel: parentItem.indentationLevel + 1,
                path: parentItem.path + "/" + $0.name
            )
        }
    }

    
    private func getItemsToRemove(for item: FileSystemItem) -> [FileSystemItem] {
        snapshot().itemIdentifiers.filter { $0.path.hasPrefix(item.path + "/") }
    }
    
    

    private func animateExpandedCells() {
        tableView.visibleCells.forEach {
            guard let cell = $0 as? FileDirectoryTableCell else { return }
            cell.isExpanding = true
            cell.animateAppearance()
        }
    }


    private func removeCollapsedItems(_ itemsToRemove: [FileSystemItem]) {
        var snapshot = self.snapshot()
        snapshot.deleteItems(itemsToRemove)
        apply(snapshot, animatingDifferences: true)
    }
    
//    private func flatten(_ directory: Directory?, parentPath: String = "", level: Int = 0) -> [FileSystemItem] {
//        guard let directory = directory else { return [] }
//        
//        var items: [FileSystemItem] = []
//        let currentPath = parentPath.isEmpty ? directory.name : "\(parentPath)/\(directory.name)"
//        items.append(FileSystemItem(entry: directory, indentationLevel: level, path: currentPath))
//        
//        for entry in directory.entries {
//            if let subDirectory = entry as? Directory {
//                items += flatten(subDirectory, parentPath: currentPath, level: level + 1)
//            } else {
//                let filePath = "\(currentPath)/\(entry.name)"
//                items.append(FileSystemItem(entry: entry, indentationLevel: level + 1, path: filePath))
//            }
//        }
//        
//        return items
//    }
    
    private func flatten(_ directory: Directory?, parentPath: String = "", level: Int = 0) -> [FileSystemItem] {
        guard let directory = directory else { return [] }
        
        var items: [FileSystemItem] = []
        let currentPath = parentPath.isEmpty ? directory.name : "\(parentPath)/\(directory.name)"
        let item = FileSystemItem(entry: directory, indentationLevel: level, path: currentPath)
        items.append(item)
        
        if expandedDirectories[currentPath] == true {
            for entry in directory.entries {
                if let subDirectory = entry as? Directory {
                    items += flatten(subDirectory, parentPath: currentPath, level: level + 1)
                } else {
                    let filePath = "\(currentPath)/\(entry.name)"
                    items.append(FileSystemItem(entry: entry, indentationLevel: level + 1, path: filePath))
                }
            }
        }
        
        return items
    }
    
    
    private func flatten(_ entries: [FileDirectoryEntry], parentPath: String = "", level: Int = 0) -> [FileSystemItem] {
        var items: [FileSystemItem] = []
        
        for entry in entries {
            let currentPath = parentPath.isEmpty ? entry.name : "\(parentPath)/\(entry.name)"
            items.append(FileSystemItem(entry: entry, indentationLevel: level, path: currentPath))
            
            if let directory = entry as? Directory {
                items += flatten(directory.entries, parentPath: currentPath, level: level + 1)
            }
        }
        
        return items
    }

    

    private func flattenedFileSystem() -> [(entry: FileDirectoryEntry, level: Int, path: String)] {
        var flattened: [(entry: FileDirectoryEntry, level: Int, path: String)] = []

        func flatten(_ entries: [FileDirectoryEntry], level: Int = 0, prefix: String = "") {
            for entry in entries {
                let path = prefix.isEmpty ? entry.name : "\(prefix)/\(entry.name)"
                flattened.append((entry: entry, level: level, path: path))
                if let directory = entry as? Directory, expandedDirectories[path] == true {
                    flatten(directory.entries, level: level + 1, prefix: path)
                }
            }
        }

        flatten(fileSystem)
        return flattened
    }
}

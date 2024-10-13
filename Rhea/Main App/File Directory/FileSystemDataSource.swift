import UIKit

final class FileSystemDataSource: UITableViewDiffableDataSource<FileSystemDataSource.Section, FileSystemItem> {

    enum Section {
        case main
    }

    var fileSystem: [FileDirectoryEntry] = []
    var expandedDirectories: [String: Bool] = [:]
    weak var tableView: UITableView!
    
    
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
    
    
    //  MARK: - Internal API
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FileSystemItem>()
        snapshot.appendSections([.main])
        let items = flattenedFileSystem().map { FileSystemItem(entry: $0.entry, indentationLevel: $0.level, path: $0.path) }
        snapshot.appendItems(items, toSection: .main)
        apply(snapshot, animatingDifferences: false)
    }


    func toggleDirectory(at indexPath: IndexPath) {
        guard let item = itemIdentifier(for: indexPath),
              item.entry.type == .folder,
              let directory = item.entry as? Directory else {
            return
        }

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

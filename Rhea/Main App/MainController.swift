import UIKit
import Combine

final class MainController: UIViewController {

    
    //  MARK: - Private Properties
    
    private let mainView = MainView()
    private lazy var dataSource = FileSystemDataSource(tableView: mainView.directoryTableView)
    private var cancellables = Set<AnyCancellable>()
    
    //  MARK: - View Lifecycle
    override func loadView() {
        view = mainView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFileDirectoryTableView()
        mainView.projectSelectionView.onButtonTap.sink { [weak self] _ in
            self?.presentDirectoryPicker()
        }.store(in: &cancellables)
    }
    
    
    private func presentDirectoryPicker() {
        iCloudDriveAccessManager.shared.pickiCloudDirectory(from: self) { [weak self] url in
            if let url = url {
                self?.updateFileSystem(with: url)
            } else {
                print("No directory was selected.")
            }
        }
    }
    


    
    //  MARK: - Private API
    
    private func setupFileDirectoryTableView() {
        mainView.directoryTableView.dataSource = dataSource
        mainView.directoryTableView.delegate = self
        dataSource.fileSystem = createDummyFileSystem()
        dataSource.applyInitialSnapshot()
    }
    
    
    
    private func updateFileSystem(with url: URL) {
        let fileSystem = createFileSystem(from: url)
        print("Updating file system with root: \(fileSystem.name)")
        dataSource.rootDirectory = fileSystem
        dataSource.applyInitialSnapshot()
    }
    

    private func createFileSystem(from url: URL) -> Directory {
        let fileManager = FileManager.default
        var rootDirectory = Directory(name: url.lastPathComponent)
        print("Creating file system for: \(url.path)")

        func addEntries(at currentURL: URL, to directory: inout Directory) {
            do {
                let contents = try fileManager.contentsOfDirectory(at: currentURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
                for fileURL in contents {
                    let relativePath = fileURL.relativePath(from: currentURL)
                    print("Processing: \(relativePath)")
                    
                    let resourceValues = try fileURL.resourceValues(forKeys: [.isDirectoryKey])
                    let isDirectory = resourceValues.isDirectory ?? false
                    
                    if isDirectory {
                        var newDirectory = Directory(name: fileURL.lastPathComponent)
                        addEntries(at: fileURL, to: &newDirectory)
                        directory.addEntry(newDirectory)
                        print("Added directory: \(newDirectory.name) to \(directory.name)")
                    } else {
                        let file = File(name: fileURL.lastPathComponent)
                        directory.addEntry(file)
                        print("Added file: \(file.name) to \(directory.name)")
                    }
                }
            } catch {
                print("Error reading directory contents: \(error)")
            }
        }

        addEntries(at: url, to: &rootDirectory)
        print("Root directory contents: \(rootDirectory.entries.map { $0.name })")
        return rootDirectory
    }
}



//  MARK: - UITableView Delegate

extension MainController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.toggleDirectory(at: indexPath)
    }
}



extension URL {
    func relativePath(from base: URL) -> String {
        let pathComponents = self.pathComponents
        let basePathComponents = base.pathComponents
        
        var i = 0
        while i < pathComponents.count && i < basePathComponents.count && pathComponents[i] == basePathComponents[i] {
            i += 1
        }
        
        return pathComponents[i...].joined(separator: "/")
    }
}

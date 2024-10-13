//
//  ViewController.swift
//  Rhea
//
//  Created by Corey Beebe on 10/12/24.
//

import UIKit


final class MainController: UIViewController {

    
    //  MARK: - Private Properties
    
    private let mainView = MainView()
    private lazy var dataSource = FileSystemDataSource(tableView: mainView.directoryTableView)
    
    
    //  MARK: - View Lifecycle
    override func loadView() {
        view = mainView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFileDirectoryTableView()
    }
    

    
    //  MARK: - Private API
    
    private func setupFileDirectoryTableView() {
        mainView.directoryTableView.dataSource = dataSource
        mainView.directoryTableView.delegate = self
        dataSource.fileSystem = createDummyFileSystem()
        dataSource.applyInitialSnapshot()
    }
}



//  MARK: - UITableView Delegate

extension MainController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.toggleDirectory(at: indexPath)
    }
}

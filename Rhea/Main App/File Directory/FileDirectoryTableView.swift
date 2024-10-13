import UIKit


final class FileDirectoryTableView: UITableView {
    
    
    //  MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .plain)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        backgroundColor = UIColor(white: 0.15, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        register(FileDirectoryTableCell.self, forCellReuseIdentifier: FileDirectoryTableCell.reuseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

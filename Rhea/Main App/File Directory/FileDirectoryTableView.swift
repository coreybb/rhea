import UIKit


final class FileDirectoryTableView: UITableView {
    
    
    //  MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .plain)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        isScrollEnabled = true // TODO: - Revert
        backgroundColor = UIColor(white: 0.15, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        contentInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 0
        )
        register(FileDirectoryTableCell.self, forCellReuseIdentifier: FileDirectoryTableCell.reuseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

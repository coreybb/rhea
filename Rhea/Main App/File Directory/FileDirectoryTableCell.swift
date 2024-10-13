import UIKit
import LazyBones


final class FileDirectoryTableCell: UITableViewCell {

    //  MARK: - Internal Properties
    
    static let reuseID = "FILE_DIRECTORY_TABLE_CELL"
    var entry: FileDirectoryEntry? {
        didSet {
            guard let entry else { return }
            iconImageView.image = entry.type.iconImage
            entryNameLabel.text = entry.name
        }
    }
    
    var entryIndentationLevel: Int = 0 {
        didSet {
            entryIndentationConstraint.constant = CGFloat(entryIndentationLevel) * entryIndentationWidth
            layoutIfNeeded()
        }
    }
    var isExpanding: Bool = false

    
    
    
    //  MARK: - Private Properties
    
    private lazy var iconImageView = UIImageView()
    private lazy var entryNameLabel = UILabel()
    private var entryIndentationConstraint: NSLayoutConstraint!
    private let entryIndentationWidth: CGFloat = 20
    
    
    
    //  MARK: - Init
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //  MARK: - Cell Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.alpha = 1
        isExpanding = false
        // ... reset other properties as needed
    }
    
    
    
    //  MARK: - Internal API
    
    func animateAppearance() {
        if isExpanding,
            contentView.alpha == 0 {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.contentView.alpha = 1
            }
        }
    }

    
    func animateDisappearance() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [],
                       animations: { [weak self] in
            self?.contentView.alpha = 0
        })
    }
    
    
    
    
    //  MARK: - Private API
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .gray
        contentView.addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    
    private func layoutUI() {
        layoutIconImageView()
        layoutNameLabel()
    }
    
    
    private func layoutIconImageView() {
        
        let dimension: CGFloat = 20
        
        entryIndentationConstraint = iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        
        contentView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: dimension),
            iconImageView.widthAnchor.constraint(equalToConstant: dimension),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            entryIndentationConstraint
        ])
    }
    
    
    private func layoutNameLabel() {
        
        let lateralPadding: CGFloat = 8
        let medialPadding: CGFloat = 8
        
        entryNameLabel.textColor = .white
        
        contentView.addSubview(entryNameLabel)
        entryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            entryNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: lateralPadding),
            entryNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -lateralPadding),
            entryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: medialPadding),
            entryNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -medialPadding)
        ])
    }
}


extension FileDirectoryTableCell: UIContextMenuInteractionDelegate {
    
    @objc
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { [weak self] _ in
            guard let self else { return nil }
            entryNameLabel.textColor = .black
            return menu(for: entry!.type)
        }
    }
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        entryNameLabel.textColor = .white
    }
    
    
    private func menu(for entryType: EntryType) -> UIMenu {
        switch entryType {
            
        case .folder:
            UIMenu(
                title: "",
                children: [
                    newFolderAction(),
                    newEmptyFileAction(),
                    renameAction(),
                    deleteAction()
                ]
            )
        case .file:
            UIMenu(
                title: "",
                children: [
                    openAction(),
                    renameAction(),
                    deleteAction()
                ]
            )
        }
    }
    
    
    func newEmptyFileAction() -> UIAction {
        UIAction(title: "New Empty File", image: UIImage(systemName: "document.badge.plus.fill")) { _ in
            print("make new empty file")
        }
    }
    
    
    func newFolderAction() -> UIAction {
        UIAction(title: "New Folder", image: UIImage(systemName: "folder.fill.badge.plus")) { _ in
            print("make new folder")
        }
    }
    
    
    func openAction() -> UIAction {
        UIAction(title: "Open", image: UIImage(systemName: "doc.text")) { _ in
            print("open file")
        }
    }
    
    
    func renameAction() -> UIAction {
        UIAction(title: "Rename", image: UIImage(systemName: "pencil")) { _ in
            print("rename")
        }
    }
    
    
    func deleteAction() -> UIAction {
        
        UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            print("delete")
        }
    }
}

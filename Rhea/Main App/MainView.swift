import UIKit
import LazyBones

final class MainView: LazyView {
    
    //  MARK: - Internal Properties
    
    let directoryTableView = FileDirectoryTableView()
    
    
    //  MARK: - Private Properties
    
    private let editorView = TextEditorView()
    private lazy var directoryWidth: NSLayoutConstraint = directoryTableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
    
    
    
    init() {
        super.init()
        backgroundColor = .black
        layoutUI()
    }
    
    
    override func didLayoutSubviews() {
//        directoryWidth.isActive = true
    }
    
    
    
    //  MARK: - Private API
    private func layoutUI() {
        
        layoutDirectoryTableView()
        layoutTextEditorView()
    }

    
    private func layoutDirectoryTableView() {


        addSubview(directoryTableView)
        NSLayoutConstraint.activate([
            directoryTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            directoryTableView.topAnchor.constraint(equalTo: topAnchor),
            directoryTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    private func layoutTextEditorView() {
        
        let leftPadding: CGFloat = 1
        
        addSubview(editorView)
        
        NSLayoutConstraint.activate([
            directoryWidth,
            editorView.leadingAnchor.constraint(equalTo: directoryTableView.trailingAnchor, constant: leftPadding),
            editorView.topAnchor.constraint(equalTo: topAnchor),
            editorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            editorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

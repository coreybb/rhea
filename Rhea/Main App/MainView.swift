import UIKit
import LazyBones

final class MainView: LazyView {
    
    //  MARK: - Internal Properties
    
    let directoryTableView = FileDirectoryTableView()
    let editorView = TextEditorView()
    
    //  MARK: - Private Properties
    
    private lazy var directoryWidth: NSLayoutConstraint = directoryTableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
    let projectSelectionView = ProjectSelectionView()
    let projectSelectionViewHeight: CGFloat = 72
    
    
    init() {
        super.init()
        backgroundColor = .black
        layoutUI()
    }
    
    
    
    //  MARK: - Private API
    private func layoutUI() {
        
        layoutDirectoryTableView()
        addPickerView()
        layoutTextEditorView()
        
    }
    
    
    private func layoutDirectoryTableView() {
        
        addSubview(directoryTableView)
        NSLayoutConstraint.activate([
            directoryTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            directoryTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: projectSelectionViewHeight),
            directoryTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    private func addPickerView() {
        
        
        addSubview(projectSelectionView)
        NSLayoutConstraint.activate([
            projectSelectionView.widthAnchor.constraint(equalTo: directoryTableView.widthAnchor),
            projectSelectionView.heightAnchor.constraint(equalToConstant: projectSelectionViewHeight),
            projectSelectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    
    private func layoutTextEditorView() {
        
        let leftPadding: CGFloat = 3
        
        addSubview(editorView)
        
        NSLayoutConstraint.activate([
            directoryWidth,
            editorView.leadingAnchor.constraint(equalTo: directoryTableView.trailingAnchor, constant: leftPadding),
            editorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            editorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            editorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    

}

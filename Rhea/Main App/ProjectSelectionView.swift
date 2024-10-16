import UIKit
import LazyBones
import Combine

struct Project {
    let name: String
}

final class ProjectSelectionView: LazyView {
    
    
    var onButtonTap = PassthroughSubject<Void, Never>()

    var projects: [Project] = [
        Project(name: "Rhea"),
        Project(name: "Bounce"),
        Project(name: "WitchHat")
    ]
    
    lazy var newFolderButton = {
        let imageOne = UIImage(systemName: "square.grid.3x1.folder.fill.badge.plus")!
        let imageTwo = UIImage(systemName: "folder.fill.badge.gear")
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(imageOne, for: .normal)
        button.imageView!.tintColor = .systemBlue
        button.imageView!.contentMode = .scaleAspectFill
        button.addAction { [weak self] _ in
            self?.onButtonTap.send()
        }
        return button
    }()
    
    
    let folderImageView = LazyImageView(image: UIImage(systemName: "folder.circle.fill")!
        .withRenderingMode(.alwaysOriginal)
        .withTintColor(.white))
    
    private lazy var pickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    
    init() {
        super.init(color: .darkGray)
        addSubview(pickerView)
        addSubview(folderImageView)
        addSubview(newFolderButton)
        
        folderImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        folderImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        folderImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        folderImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        newFolderButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        newFolderButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        newFolderButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        newFolderButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        pickerView.leadingAnchor.constraint(equalTo: folderImageView.trailingAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: newFolderButton.leadingAnchor).isActive = true
        

        
    }
}


extension ProjectSelectionView: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        projects.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = projects[row].name
        return label
    }
    
    
}

extension ProjectSelectionView: UIPickerViewDelegate {
    
    
}
